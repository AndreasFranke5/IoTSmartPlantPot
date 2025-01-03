/* eslint-disable indent */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const admin = require('firebase-admin');

// Fetch the service account key JSON file contents
// eslint-disable-next-line max-len

const auth = require('./authentication');
const user = require('./user');
const plant = require('./plant');

console.log(
  // eslint-disable-next-line comma-dangle
  process.env.FUNCTIONS_EMULATOR ? 'Running locally' : 'Running in Firebase'
);

if (process.env.FUNCTIONS_EMULATOR) {
  // Running locally
  // eslint-disable-next-line max-len
  const serviceAccount = require('/Users/prageeth-dev/Documents/Uni/1-1/IOT/Project/service.json');
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL:
      'https://smart-plant-pot-iot-default-rtdb.europe-west1.firebasedatabase.app',
  });
} else {
  // Running in Firebase environment
  admin.initializeApp();
}

exports.createUser = auth.createUser;
exports.login = auth.login;
exports.loginWithGoogle = auth.loginWithGoogle;
exports.getUser = user.getUser;
exports.addDevice = user.addDevice;
exports.addNewPlant = user.addNewPlant;
exports.getUserDevices = user.getUserDevices;
exports.getUserPlants = user.getUserPlants;
exports.getPlantData = plant.getPlantData;
exports.getPredefinedPlants = plant.getPredefinedPlants;
exports.sendPlantUpdates = plant.sendPlantUpdates;
