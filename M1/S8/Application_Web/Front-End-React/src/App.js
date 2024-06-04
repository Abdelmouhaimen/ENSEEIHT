import React, { useEffect, useState } from "react";
import { BrowserRouter as Router, Route, Routes, Navigate } from "react-router-dom";
import "./style.css";

import Login from "./Login";
import Home from "./Home";
import Quiz from "./Quiz";
import AccueilEleve from "./AccueilEleve";
import Navbar from "./components/Navbar";
import Preloader from "./components/Pre";
import CreationTest from "./CreationTest";
import CoursProf from "./CoursProf";
import Quizprof from "./Quizprof";
import Accueilprof from "./Accueilprof";
import Choixprof from "./Choixprof";
import CoursEleve from "./CoursEleve.js";

function App() {
  const [load, updateLoad] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => {
      updateLoad(false);
    }, 1200);

    return () => clearTimeout(timer);
  }, []);



  return (
    <Router>
      <Preloader load={load} />
      <div className="App" id={load ? "no-scroll" : "scroll"}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          <Route path="*" element={<Navigate to="/"/>} />
          <Route path="/quiz/:id" element={<Quiz />} />
          <Route path='/Quiz' element = {<Quiz/>}/>
          <Route path='/Creationtest/:id' element = {<CreationTest/>}/>
          <Route path='/Accueilprof' element = {<Accueilprof/>}/>
          <Route path='/Accueileleve' element = {<AccueilEleve/>}/>
          <Route path="/choix/:id/:title" element ={<Choixprof />}/>
          <Route path="/coursprof/:id/:title" element ={<CoursProf />}/>
          <Route path="/courseleve/:id/:title" element ={<CoursEleve />}/>
          <Route path="/visualiseetu/:id" element ={<Quizprof />}/>
        </Routes>
      </div>
    </Router>
  );
}

export default App;
