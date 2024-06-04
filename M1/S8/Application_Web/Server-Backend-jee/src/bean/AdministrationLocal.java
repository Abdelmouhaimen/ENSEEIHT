package bean;

import java.util.Collection;
import java.util.List;

import javax.ejb.Local;

import entities.Answer;
import entities.Course;
import entities.Question;
import entities.Quiz;
import entities.Response;
import entities.User;

@Local
public interface AdministrationLocal {
	public User authenticate(String username, String password);

	public Collection<Course> getCourses();

	public Collection<Quiz> getQuizzes(Long courseId);
	
	public Collection<Quiz> getQuizzes(Long courseId, String username);

	public Collection<Question> getQuestions(Long quizId);
	
	public Question createQuestion(String questionText, String correctAnswer, List<String> choices, String type);
	
	public Quiz createQuiz(String titre, float duration, Collection<Question> questions, Course course);
	
	public Quiz createQuiz(String titre, float duration, Collection<Question> questions, long course_id);
	
	public float getDuration(Long quizId);
	
	public Answer createAnswer( String answerText,Long questionId);
	
	public Response createResponse(Long quizId, String username, List<Answer> AnswerCollection);
	
	public Collection<Response> getResponsesByQuizId(Long quizId);
	
}
