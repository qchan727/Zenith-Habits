importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");


const firebaseConfig = {
    apiKey: "AIzaSyBXo_kRoQYtzr3mffTUFWr2h1kT0uS4XCM",
    authDomain: "zenith-habits.firebaseapp.com",
    projectId: "zenith-habits",
    storageBucket: "zenith-habits.appspot.com",
    messagingSenderId: "150930906470",
    appId: "1:150930906470:web:bf77a2e709a320f7aa3ca7",
    measurementId: "G-757C7PB6F0"
  };

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});