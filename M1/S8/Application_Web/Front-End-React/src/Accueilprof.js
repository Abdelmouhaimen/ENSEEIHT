import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Link, Switch, useParams } from 'react-router-dom';
import './Accueilprof.css';
import { RiArrowRightDoubleFill } from "react-icons/ri";
import Navbar from './components/Navbar';

function Accueilprof() {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
useEffect(() => {
        fetch('/API/groups')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                setCourses(data);
                setLoading(false);
            })
            .catch(error => {
                setError(error);
                setLoading(false);
            });
    }, []); 


    if (loading) {
        return <div>Loading...</div>;
    }



    return (
      <>
      <Navbar/>
      <div className="course-category">
          <h1>Catégories de cours</h1>
          <ul>
              {courses.map(course => (
                  <li key={course.id}>
                      <RiArrowRightDoubleFill />
                      <Link to={`/choix/${course.id}/${course.title}`}>{course.title}</Link>
                  </li>
              ))}
          </ul>
      </div>
      </>

    );
}
export default Accueilprof;