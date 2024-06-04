import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import bean.AdministrationLocal;
import entities.Answer;
import entities.Question;
import entities.Quiz;
/**
 * Servlet implementation class Quiz
 */
@WebServlet("/quiz")
public class quiz extends HttpServlet {
	@EJB
    private AdministrationLocal administration;
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public quiz() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Check if there is a session and if the username can be found in the session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Unauthorized"));
            return;
        }

        // Retrieve the course ID from the request parameters
        String quizIdString = request.getParameter("id");
        if (quizIdString == null || quizIdString.isEmpty()) {
        	response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Parse the course ID string to a Long
        Long quizId = Long.parseLong(quizIdString);
        
        


        try {
            // Get the quiz questions using the AdministrationLocal bean
            Collection<Question> questions = administration.getQuestions(quizId);
            float duration = administration.getDuration(quizId);

            

         // Prepare JSON response
            Map<String, Object> quizMap = new HashMap<>();
            quizMap.put("duration", duration);
            
            List<Map<String, Object>> questionsJson = new ArrayList<>();
            for (Question question : questions) {
                Map<String, Object> questionMap = new HashMap<>();
                questionMap.put("id_question", question.getId());
                questionMap.put("question", question.getQuestion());
                questionMap.put("type", question.getType());
                questionMap.put("choices", question.getChoices());

                questionsJson.add(questionMap);
            }
            quizMap.put("questions", questionsJson);

            // Send JSON response
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), quizMap);
        } catch (Exception e) {
            // Handle any exceptions that might occur
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Internal Server Error"));
        }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
