import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

exports.initializeUserData = functions.auth.user().onCreate(async (user) => {
  const uid = user.uid;
  const firestore = admin.firestore();

  const defaultHorarios = {
    segunda: {
      id: 1,
      working: true,
      startTime: 480,
      endTime: 960,
      startTimeInterval: 720,
      endTimeInterval: 780,
    },
    terca: {
      id: 2,
      working: true,
      startTime: 480,
      endTime: 960,
      startTimeInterval: 720,
      endTimeInterval: 780,
    },
    quarta: {
      id: 3,
      working: true,
      startTime: 480,
      endTime: 960,
      startTimeInterval: 720,
      endTimeInterval: 780,
    },
    quinta: {
      id: 4,
      working: true,
      startTime: 480,
      endTime: 960,
      startTimeInterval: 720,
      endTimeInterval: 780,
    },
    sexta: {
      id: 5,
      working: true,
      startTime: 480,
      endTime: 960,
      startTimeInterval: 720,
      endTimeInterval: 780,
    },
    sabado: {
      id: 6,
      working: false,
      startTime: 480,
      endTime: 960,
      startTimeInterval: 720,
      endTimeInterval: 780,
    },
    domingo: {
      id: 0,
      working: true,
      startTime: 480,
      endTime: 960,
      startTimeInterval: 720,
      endTimeInterval: 780,
    },
  };

  await firestore.collection("horarios").doc(uid).set(defaultHorarios);
  console.log(`Dados iniciais criados para o usuário: ${uid}`);
});
