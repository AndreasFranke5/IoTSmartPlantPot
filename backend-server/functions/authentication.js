const { onRequest } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

exports.createUser = onRequest(async (request, response) => {
  try {
    const { email, password, name } = request.body;

    if (!email || !password || !name) {
      response.status(400).send('Invalid input');
      return;
    }

    // Create user in Firebase Authentication
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: name,
    });

    // Store additional user information in the Realtime Database
    const userId = userRecord.uid;
    await admin.database().ref(`users/${userId}`).set({
      id: userId,
      name: name,
      email: email,
    });

    response.status(201).send('User created successfully');
  } catch (error) {
    console.error('Error creating user:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.loginWithGoogle = onRequest(async (request, response) => {
  try {
    const { idToken } = request.body;

    if (!idToken) {
      response.status(400).send('Invalid input');
      return;
    }

    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { uid, email, name, picture } = decodedToken;

    // Check if the user already exists
    try {
      await admin.auth().getUser(uid);
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        // Create a new user if not found
        await admin.auth().createUser({
          uid: uid,
          email: email,
          displayName: name,
        });
      } else {
        throw error;
      }
    }

    // Store additional user information in the Realtime Database
    const userRef = admin.database().ref(`users/${uid}`);

    await userRef.set({
      id: uid,
      name: name,
      email: email,
      image: picture,
    });

    userRef.once('value', (snapshot) => {
      const user = snapshot.val();
      response.status(200).json({ ...user, idToken });
    });
  } catch (error) {
    console.error('Error creating user:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.login = onRequest(async (request, response) => {
  try {
    const { idToken } = request.body;

    if (!idToken) {
      response.status(400).send('Invalid input');
      return;
    }

    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { uid } = decodedToken;

    const userRef = admin.database().ref(`users/${uid}`);
    await userRef.once('value', (snapshot) => {
      const user = snapshot.val();
      response.status(200).json({ ...user, idToken });
    });
  } catch (error) {
    console.error('Error creating user:', error);
    response.status(500).send('Internal Server Error');
  }
});
