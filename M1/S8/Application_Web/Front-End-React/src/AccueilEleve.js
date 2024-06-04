import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import './AccueilEleve.css';
import Navbar from './components/Navbar';
import { RiArrowRightDoubleFill } from "react-icons/ri";


const AccueilEleve = () => {
    const [courses, setCourses] = useState([]);

    useEffect(() => {
        // Fetch groups data from the backend API
        const fetchGroups = async () => {
            try {
                const response = await fetch('API/groups');
                if (response.ok) {
                    const data = await response.json();
                    setCourses(data);
                } else {
                    console.error('Failed to fetch groups data');
                }
            } catch (error) {
                console.error('Error fetching groups data:', error);
            }
        };

        fetchGroups();
    }, []);

    return (
        <>
        <Navbar/>
        <div className="course-category">
            <h1>Catégories de cours</h1>
            <ul>
                {courses.map(course => (
                    <li key={course.id}>
                        <RiArrowRightDoubleFill />
                        <Link to={`/courseleve/${course.id}/${course.title}`}>{course.title}</Link>
                    </li>
                ))}
            </ul>
        </div>
        </>
    );
};

export default AccueilEleve;
