import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { MdOutlineQuiz } from "react-icons/md";
import { BrowserRouter as Router, Route, Link, Switch } from 'react-router-dom';
import Navbar from './components/Navbar';
import './CoursEleve.css'
function CoursEleve() {
    const { id, title } = useParams();
    const [quizzes, setQuizzes] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    

    useEffect(() => {
        fetch(`/API/course?id=${id}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                setQuizzes(data);
                setLoading(false);
            })
            .catch(error => {
                setError(error);
                setLoading(false);
            });
    }, [id]);


    if (loading) {
        return <div>Loading...</div>;
    }



    return (
        <>
        <Navbar/>
        <div className="course-category">
            <h1>Quizzes for : {title}</h1>
            <ul>
                {quizzes.map(quiz => (
                    <li key={quiz.id}><Link to={`/quiz/${quiz.id}`}>
                        <MdOutlineQuiz/>
                        {quiz.title}</Link></li>
                ))}
            </ul>
        </div>
        </>
    );
}

export default CoursEleve;