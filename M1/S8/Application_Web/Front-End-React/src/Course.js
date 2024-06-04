import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';

const Course = () => {
    const { id } = useParams(); // Extract the id parameter from the URL

    const [quizTitles, setQuizTitles] = useState([]);

    useEffect(() => {
        // Fetch quiz titles data from the backend API based on the course id
        const fetchQuizTitles = async () => {
            try {
                const response = await fetch(`/API/course?id=${id}`);
                if (response.ok) {
                    const data = await response.json();
                    setQuizTitles(data);
                } else {
                    console.error('Failed to fetch quiz titles data');
                }
            } catch (error) {
                console.error('Error fetching quiz titles data:', error);
            }
        };

        fetchQuizTitles();
    }, [id]);

    return (
        <div>
            <h2>Quiz disponibles :</h2>
            <ul>
                {quizTitles.map(quiz => (
                    <li key={quiz.id}>
                        <Link to={{ pathname: `/quiz/${quiz.id}` }}>{quiz.title}</Link>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default Course;
