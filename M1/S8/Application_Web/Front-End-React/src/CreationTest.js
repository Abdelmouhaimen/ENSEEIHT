import { useEffect, useState } from "react";
import Navbar from "./components/Navbar";
import "./CreationTest.css";
import { MdDelete } from "react-icons/md";
import { useParams } from "react-router-dom";
import { useNavigate } from 'react-router-dom';

function CreationTest() {
    const navigate = useNavigate(); // Use the navigate hook to navigate to another route
    const { id } = useParams();
    const [titlequiz, setTitlequiz] = useState("Untitled Quiz");
    const [duration, setDuration] = useState(0);
    const [fin, setfin] = useState(false);
    const [questiontext, setQuestiontext] = useState("");
    const [listchoices, setListchoices] = useState([]);
    const [choix, setChoix] = useState("checkbox");
    const [listquestion, setListquestion] = useState([]);
    const [choice, setchoice] = useState("");
    const [response, setResponse] = useState([]);

    const handleCheckboxChange = (event) => {
        const itemName = event.target.name;
        const isChecked = event.target.checked;

        if (isChecked) {
            setResponse([...response, itemName]);
        } else {
            setResponse(response.filter(item => item !== itemName));
        }
    }

    function ajouterQuestion() {
        setListquestion(prev => [...prev, {
            question: questiontext,
            choices: listchoices,
            type: choix,
            correctAnswer: response
        }]);

        setQuestiontext("");
        setListchoices([]);
        setchoice("");
        setChoix("checkbox");
        setResponse([]);
    }

    function renderallquestion() {
        return (
            listquestion.map((q, index) => {
                return (
                    <div className="question-from-top" key={index}>
                        <h1>Question:</h1>
                        <div className="row">
                            <p>{q.question}</p>
                        </div>
                        <br></br>
                        {q.type === "paragraphe" ? null :
                            <>
                                <h1>Choices:</h1>
                                <ul>
                                    {q.choices.map((item, i) => (
                                        <div className="choice" key={i}>
                                            <li>{item}</li>
                                        </div>
                                    ))}
                                </ul>
                                <h1>Correct Answers:</h1>
                                <ul>
                                    {q.correctAnswer.map((item, i) => (
                                        <div className="correctAnswer" key={i}>
                                            <li>{item}</li>
                                        </div>
                                    ))}
                                </ul>
                            </>
                        }
                    </div>
                );
            })
        );
    }

    function Question() {
        return (
            <div className="question-from-top">
                <h1>Question:</h1>
                <div className="row">
                    <input type="textarea"
                        className="question"
                        value={questiontext}
                        placeholder="Add question"
                        onChange={(e) => { setQuestiontext(e.target.value) }} />
                    <div className="select">
                        <select id="mySelect" onChange={(e) => { setChoix(e.target.value) }} value={choix}>
                            <option value="checkbox">Checkbox</option>
                            <option value="radio">Radio</option>
                        </select>
                    </div>
                </div>
                <br></br>
                {renderop()}
            </div>
        );
    }

    useEffect(() => {
        setListchoices([]);
        setResponse([]);
    }, [choix]);

    function addchoice() {
        setListchoices(prev => [...prev, choice]);
        setchoice("");
    }

    function deleteoption(key) {
        setResponse(prev => prev.filter(item => item !== listchoices[key]));
        setListchoices(prev => prev.filter((_, i) => i !== key));
    }

    function renderop() {
        switch (choix) {
            case "checkbox":
                return (
                    <>
                        <h1>Add choices:</h1>
                        <div className="row-choix">
                            <input type="text"
                                className="question"
                                placeholder="Add option"
                                value={choice}
                                onChange={(e) => { setchoice(e.target.value) }} />
                            <button onClick={() => { addchoice() }}>Add option</button>
                        </div>
                        <ul>
                            {listchoices.map((item, i) => (
                                <div className="choice" key={i}>
                                    <li>
                                        <label>
                                            <input
                                                type="checkbox"
                                                name={item}
                                                checked={response.includes(item)}
                                                onChange={handleCheckboxChange} />
                                            {item}
                                        </label>
                                    </li>
                                    <MdDelete onClick={() => { deleteoption(i) }} />
                                </div>
                            ))}
                        </ul>
                        {response}
                    </>
                );
            case "radio":
                return (
                    <>
                        <h1>Add choices:</h1>
                        <div className="row-choix">
                            <input type="text"
                                className="question"
                                placeholder="Add option"
                                value={choice}
                                onChange={(e) => { setchoice(e.target.value) }} />
                            <button onClick={() => { addchoice() }}>Add option</button>
                        </div>
                        <ul>
                            {listchoices.map((item, i) => (
                                <div className="choice" key={i}>
                                    <li>
                                        <label>
                                            <input type="radio" name="options" value={item}
                                                onChange={(e) => { setResponse([e.target.value]) }} />
                                            {item}
                                        </label>
                                    </li>
                                    <MdDelete onClick={() => { deleteoption(i) }} />
                                </div>
                            ))}
                        </ul>
                        {response}
                    </>
                );
            default: return null;
        }
    }

    function handleSubmit() {
        const quiz = {
            duration: duration * 60, // Convert duration to seconds
            questions: listquestion,
            title: titlequiz,
            id: parseInt(id)
        }
        fetch('/API/createQuiz', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(quiz)
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Success:', data);
            })
            .catch(error => {
                console.error('Error:', error);
            });

        navigate(`/AcceuilProf`)
    }

    return (
        <>
            <Navbar />
            <div>
                <div className="question-from">
                    <br></br>
                    <div className="section">
                        <div className="question-title-section">
                            <div className="question-from-top">
                                <input type="text" className="question-from-top-name"
                                    value={titlequiz}
                                    onChange={(e) => setTitlequiz(e.target.value)}
                                    style={{ color: "black" }} />
                                <input type="number" className="question-from-top-desc"
                                    value={duration}
                                    onChange={(e) => setDuration(e.target.value)}
                                    min={0}
                                />
                            </div>
                        </div>
                        <br></br>
                        {fin ? renderallquestion() : Question()}
                        {fin ? <button onClick={handleSubmit}>Submit</button>
                            : <>
                                <button onClick={ajouterQuestion}>Add question</button>
                                <button onClick={() => { setfin(true) }}>Review</button>
                            </>}
                    </div>
                </div>
            </div>
        </>
    )
}

export default CreationTest;
