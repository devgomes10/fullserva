import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fullserva/data/repositories/offering_repository.dart';
import 'package:fullserva/data/repositories/opening_hours_repository.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/coworker.dart';
import '../../domain/entities/offering.dart';
import '../../utils/formatting/minutes_to_time_of_day.dart';
import '../../views/components/is_time_in_interval.dart';

class AppointmentRepository {
  late String uidAppointment;
  late CollectionReference appointmentCollection;
  FirebaseFirestore db = FirebaseFirestore.instance;

  AppointmentRepository() {
    uidAppointment = FirebaseAuth.instance.currentUser!.uid;
    appointmentCollection = db.collection("appointment_$uidAppointment");
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await appointmentCollection.doc(appointment.id).set(appointment.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<Appointment>> getAppointments() {
    return appointmentCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return Appointment(
              id: doc["id"],
              clientName: doc["clientName"],
              coworkerId: doc["coworkerId"],
              clientPhone: doc["clientPhone"],
              offeringId: doc["offeringId"],
              dateTime: (doc["dateTime"] as Timestamp).toDate(),
              observations: doc["observations"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await appointmentCollection
          .doc(appointment.id)
          .update(appointment.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<void> removeAppointment(String appointment) async {
    try {
      await appointmentCollection.doc(appointment).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<List<Appointment>> getAppointmentsByCoworkerAndDate(
    Coworker? selectedCoworker,
    DateTime? selectedDate,
  ) async {
    try {
      QuerySnapshot querySnapshot = await appointmentCollection
          .where("coworkerId", isEqualTo: selectedCoworker!.id)
          .where("dateTime",
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                  DateTime(selectedDate!.year, selectedDate.month, selectedDate.day, 0, 0, 0)))
          .where("dateTime",
              isLessThanOrEqualTo: Timestamp.fromDate(
                DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59),
              ))
          .get();

      List<Appointment> appointments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Appointment(
          id: data['id'],
          clientName: data['clientName'],
          coworkerId: data['coworkerId'],
          clientPhone: data['clientPhone'],
          offeringId: data['offeringId'],
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          observations: data['observations'],
        );
      }).toList();

      return appointments;
    } catch (error) {
      print("Erro ao buscar os agendamentos: $error");
      rethrow;
    }
  }

  Future<List<Map<String, TimeOfDay>>> calculateBusyTimes(
    List<Appointment> appointments,
    Offering? selectedOffering,
  ) async {
    List<Map<String, TimeOfDay>> busyTimes = [];

    try {
      for (var appointment in appointments) {
        // Obtenção do horário inicial do agendamento
        DateTime startDateTime = appointment.dateTime;
        // print("data e hora inicial: $startDateTime");

        // Obtenção do ID do serviço associado ao agendamento
        String offeringIdOfAppointment = appointment.offeringId;
        // print("id do serviço: $offeringIdOfAppointment");

        // Consulta ao Firestore para obter os detalhes do serviço
        DocumentSnapshot offeringSnapshot = await FirebaseFirestore.instance
            .collection('offering_${OfferingRepository().uidOffering}')
            .doc(offeringIdOfAppointment)
            .get();
        // print("consulta do serviço: $offeringSnapshot");

        if (offeringSnapshot.exists) {
          // Extrair a duração do serviço (em minutos) do documento obtido
          int serviceDuration = offeringSnapshot['duration'];
          // print("duração do serviço: $serviceDuration");

          // Consulta ao Firestore para obter os detalhes do serviço selecionado
          DocumentSnapshot selectedOfferingSnapshot = await FirebaseFirestore
              .instance
              .collection('offering_${OfferingRepository().uidOffering}')
              .doc(selectedOffering!.id)
              .get();

          // Extrair a duração do serviço selecionado (em minutos)
          int selectedServiceDuration = selectedOfferingSnapshot['duration'];

          // Cálculo do horário final (horário inicial + duração do serviço)
          DateTime endDateTime =
              startDateTime.add(Duration(minutes: serviceDuration));
          // print("data e hora final: $endDateTime");

          // redefinindo horário inicial do agendamento
          startDateTime = startDateTime
              .subtract(Duration(minutes: selectedServiceDuration - 1));

          // Criar mapa com os horários ocupados (start e end)
          Map<String, TimeOfDay> busyTime = {
            'start': TimeOfDay.fromDateTime(startDateTime),
            'end': TimeOfDay.fromDateTime(endDateTime),
          };
          // print("busyTime: $endDateTime");

          // Adicionar o mapa à lista de horários ocupados
          busyTimes.add(busyTime);
          // print("o retorno busyTimes: $busyTimes");
        } else {
          // não existe mais o serviço que foi agendado
        }
      }
    } catch (error) {
      print("Erro ao calcular horários ocupados: $error");
      return [];
    }

    // Retornar a lista de horários ocupados calculados
    return busyTimes;
  }

  Future<List<TimeOfDay>> startTimeToEndTimeList(
    DateTime dateTime,
    Offering? selectedOffering,
  ) async {
    final int weekday = dateTime.weekday;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("opening_hours_${OpeningHoursRepository().uidOpeningHours}")
        .doc("$weekday")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      bool isWorking = data['working'] ?? false;

      if (isWorking) {
        int startTime = data['startTime'];
        int endTime = data['endTime'];

        // pegando o horário de intervalo do dia
        int startTimeInterval = data['startTimeInterval'];
        int endTimeInterval = data['endTimeInterval'];

        // Consulta ao Firestore para obter os detalhes do serviço selecionado
        DocumentSnapshot selectedOfferingSnapshot = await FirebaseFirestore
            .instance
            .collection('offering_${OfferingRepository().uidOffering}')
            .doc(selectedOffering!.id)
            .get();

        // Extrair a duração do serviço selecionado (em minutos)
        int selectedServiceDuration = selectedOfferingSnapshot['duration'];

        TimeOfDay startTimeOfDay = minutesToTimeOfDay(startTime);
        TimeOfDay endTimeOfDay = minutesToTimeOfDay(endTime);

        TimeOfDay startIntervalTimeOfDay =
            minutesToTimeOfDay(startTimeInterval);
        TimeOfDay endIntervalTimeOfDay = minutesToTimeOfDay(endTimeInterval);

        DateTime now = DateTime.now();
        DateTime dateTimeWithTimeOfDay = DateTime(
          now.year,
          now.month,
          now.day,
          startIntervalTimeOfDay.hour,
          startIntervalTimeOfDay.minute,
        );

        dateTimeWithTimeOfDay = dateTimeWithTimeOfDay
            .subtract(Duration(minutes: selectedServiceDuration - 1));

        startIntervalTimeOfDay = TimeOfDay.fromDateTime(dateTimeWithTimeOfDay);

        List<TimeOfDay> timeList = [];
        TimeOfDay currentTime = startTimeOfDay;

        while (currentTime != endTimeOfDay) {
          timeList.add(currentTime);
          int minutes = currentTime.hour * 60 + currentTime.minute + 15;
          currentTime = minutesToTimeOfDay(minutes);
        }
        timeList.add(endTimeOfDay);

        // Filtrar os horários para remover os intervalos ocupados
        List<TimeOfDay> filteredTimes = [];
        for (var time in timeList) {
          if (!isTimeInInterval(
              time, startIntervalTimeOfDay, endIntervalTimeOfDay)) {
            filteredTimes.add(time);
          }
        }

        return filteredTimes;
      } else {
        // se for um dia que não trabalha
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List<TimeOfDay>> getAvailableTimes(
      List<Map<String, TimeOfDay>> busyTimes,
    DateTime? selectedDate,
    Offering? selectedOffering,
  ) async {
    // 1. Obter a lista completa de horários disponíveis para o dia selecionado
    List<TimeOfDay> availableTimes =
        await startTimeToEndTimeList(selectedDate!, selectedOffering);

    // 2. Criar uma lista de intervalos ocupados com início e fim
    List<TimeOfDay> busyStartTimes = [];
    List<TimeOfDay> busyEndTimes = [];

    for (var busyTime in busyTimes) {
      busyStartTimes.add(busyTime['start']!);
      busyEndTimes.add(busyTime['end']!);
    }

    // 3. Filtrar os horários disponíveis removendo os intervalos ocupados
    List<TimeOfDay> filteredTimes = [];

    for (var time in availableTimes) {
      bool isAvailable = true;

      // Verificar se o horário atual está dentro de qualquer intervalo ocupado
      for (int i = 0; i < busyStartTimes.length; i++) {
        if (isTimeInInterval(time, busyStartTimes[i], busyEndTimes[i])) {
          isAvailable = false;
          break;
        }
      }

      // Se o horário estiver disponível, adicionar à lista filtrada
      if (isAvailable) {
        filteredTimes.add(time);
      }
    }

    // 4. Retornar a lista de horários disponíveis após a filtragem
    return filteredTimes;
  }

  // Future<void> sendEmail() async {
  //   final email = "viniciusgomesccc10@gmail.com";
  //
  //   final smtpServer = gmailSaslXoauth2(email, accessToken);
  //   final message = Message()
  //   ..from = Address(email, "Vinicius")
  //   .. recipients = ["geoovanarodriguess224@gmail.com"]
  //   ..subject = "Hello Gi"
  //   ..text = "This is a test emial";
  //
  //   try {
  //     await send(message, smtpServer);
  //
  //     SnackBar(content: Text("Email enviado com sucesso"));
  //   } on MailerException catch (e) {
  //     print(e);
  //   }
  // }
}
