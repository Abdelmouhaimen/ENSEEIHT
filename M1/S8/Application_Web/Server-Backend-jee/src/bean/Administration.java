package bean;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;

import javax.annotation.PostConstruct;
import javax.ejb.Singleton;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;


import entities.*;

@Singleton
public class Administration implements AdministrationLocal {

    @PersistenceContext(unitName = "MaPU")
    private EntityManager entityManager;

    @PostConstruct
    public void init() {
        // Initialize users
        Professor admin = new Professor();
        admin.setUsername("admin");
        admin.setPassword("admin");
        admin.setType("PROFESSOR");
        entityManager.persist(admin);
        
        
        // Initialize user "asarhane"
        Student asarhane = new Student();
        asarhane.setUsername("asarhane");
        asarhane.setPassword("asarhane");
        asarhane.setType("STUDENT");
        asarhane.setGroups(new ArrayList<>()); // Initialize the groups collection
        entityManager.persist(asarhane);

        // Create a new group
        Course newCourse = new Course();
        newCourse.setTitle("OpenMP"); // Set the title of the new group
        newCourse.setStudents(new ArrayList<>());
        newCourse.setQuizzes(new ArrayList<>());
        newCourse.getStudents().add(asarhane);
        entityManager.persist(newCourse);
        
        // Create a new group
        newCourse = new Course();
        newCourse.setTitle("Applications Web"); // Set the title of the new group
        newCourse.setStudents(new ArrayList<>());
        newCourse.setQuizzes(new ArrayList<>());
        newCourse.getStudents().add(asarhane);
        entityManager.persist(newCourse);
        
        // Create a new group
        newCourse = new Course();
        newCourse.setTitle("Base de donnees"); // Set the title of the new group
        newCourse.setStudents(new ArrayList<>());
        newCourse.setQuizzes(new ArrayList<>());
        newCourse.getStudents().add(asarhane);
        entityManager.persist(newCourse);
        
        // Create a new group
        newCourse = new Course();
        newCourse.setTitle("Image, Modelisation et Rendu"); // Set the title of the new group
        newCourse.setStudents(new ArrayList<>());
        newCourse.setQuizzes(new ArrayList<>());
        newCourse.getStudents().add(asarhane);
        entityManager.persist(newCourse);
        
        // Create a new group
        newCourse = new Course();
        newCourse.setTitle("Programmation Mobile et apprentissage profond"); // Set the title of the new group
        newCourse.setStudents(new ArrayList<>());
        newCourse.setQuizzes(new ArrayList<>());
        newCourse.getStudents().add(asarhane);
        entityManager.persist(newCourse);
        
        // Create a new group
        newCourse = new Course();
        newCourse.setTitle("Traitement des donnees audio-visuelles"); // Set the title of the new group
        newCourse.setStudents(new ArrayList<>());
        newCourse.setQuizzes(new ArrayList<>());
        newCourse.getStudents().add(asarhane);
        entityManager.persist(newCourse);
        
        	

    }
    
    public User authenticate(String username, String password) {
        User user = entityManager.find(User.class, username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }
    
    
    public Collection<Course> getCourses() {
    	// Create a JPQL query to fetch all courses
        TypedQuery<Course> query = entityManager.createQuery("SELECT c FROM Course c", Course.class);
        
        // Get the result list from the query
        Collection<Course> courses = query.getResultList();
        
        // Return the list of courses
        return courses;
    }

	@Override
	public Collection<Quiz> getQuizzes(Long courseId) {
		Course course = (Course) entityManager.find(Course.class, courseId);
		
        if (course != null) {
        	// TODO change this t5rbe9a : course.getquizes isn't loaded without manipulating it first, best no, working yes, weird yes
        	course.getQuizzes().size();
            return course.getQuizzes();
       }
       return null;
	}
	
	@Override
	public Collection<Quiz> getQuizzes(Long courseId, String username) {
	    // Retrieve the course by ID
	    Course course = entityManager.find(Course.class, courseId);

	    if (course != null) {
	        // Fetch all quizzes for the course
	        Collection<Quiz> courseQuizzes = course.getQuizzes();

	        // Fetch the responses of the user
	        String jpqlResponses = "SELECT r.quiz.id FROM Response r WHERE r.student.username = :username";
	        List<Long> respondedQuizIds = entityManager.createQuery(jpqlResponses, Long.class)
	                                                   .setParameter("username", username)
	                                                   .getResultList();

	        // Filter out the quizzes that the user has already responded to
	        Collection<Quiz> filteredQuizzes = new ArrayList<>();
	        for (Quiz quiz : courseQuizzes) {
	            if (!respondedQuizIds.contains(quiz.getId())) {
	                filteredQuizzes.add(quiz);
	            }
	        }

	        return filteredQuizzes;
	    }
	    return Collections.emptyList();
	}
	
	@Override
	public Collection<Question> getQuestions(Long quizId) {
		Quiz quiz = (Quiz) entityManager.find(Quiz.class, quizId);
		
        if (quiz != null) {
        	// TODO change this t5rbe9a : course.getquizes isn't loaded without manipulating it first, best no, working yes, weird yes
        	System.out.println(quiz.getQuestions().size());
            return quiz.getQuestions();
       }
       return null;
	}

	@Override
    public float getDuration(Long quizId) {
        Quiz quiz = (Quiz) entityManager.find(Quiz.class, quizId);
        if (quiz != null) {
            return quiz.getDuration();
        }
        return Float.MAX_VALUE;
    }
	
	public Question createQuestion(String questionText, String correctAnswer, List<String> choices, String type) {
        Question question = new Question();
        question.setQuestion(questionText);
        question.setCorrectAnswer(correctAnswer);
        question.setChoices(choices);
        question.setType(type); // Assuming it's a multiple choice question

        entityManager.persist(question);
        return question;
    }
	
	public Quiz createQuiz(String titre, float duration, Collection<Question> questions, Course course) {
        Quiz quiz = new Quiz();
        quiz.setTitre(titre);
        quiz.setDuration(duration);
        quiz.setQuestions(new ArrayList<>());
        quiz.setGroup(course);

        // Persist the quiz
        entityManager.persist(quiz);
        

        // Associate each question with the quiz
        for (Question question : questions) {
            question.setQuiz(quiz);
            entityManager.merge(question);
        }
        
        

        return quiz;
    }
	
	public Quiz createQuiz(String titre, float duration, Collection<Question> questions, long course_id) {
        Course course = (Course) entityManager.find(Course.class, course_id);
		return createQuiz(titre, duration, questions, course);
    }
	
	public Answer createAnswer( String answerText,Long questionId) {
        Answer answer = new Answer(); 
        Question question = entityManager.find(Question.class, questionId);
        answer.setAnswer(answerText);
        answer.setQuestion(question);
        entityManager.persist(answer);
        return answer ;
	}
	
	public Response createResponse(Long quizId, String username, List<Answer> AnswerCollection) {
        Quiz quiz = entityManager.find(Quiz.class, quizId);
        Student student = entityManager.find(Student.class, username);
        
        if (quiz == null || student == null) {
            throw new RuntimeException("Quiz or Student not found");
        }
        
        Response response = new Response();
        response.setQuiz(quiz);
        response.setStudent(student);
        entityManager.persist(response);

        int score = 0;
        for (Answer answer : AnswerCollection) {
            Question question = answer.getQuestion();
            if (question.getCorrectAnswer().equals(answer.getAnswer())) {
                score++;
            }
            answer.setResponse(response);
            entityManager.merge(answer);
        }
        
        response.setScore(score);
        entityManager.merge(response);
        
        
        return response;
    }
	
	public Collection<Response> getResponsesByQuizId(Long quizId) {
        TypedQuery<Response> query = entityManager.createQuery(
            "SELECT r FROM Response r WHERE r.quiz.id = :quizId", Response.class);
        query.setParameter("quizId", quizId);
        return query.getResultList();
    }
}
