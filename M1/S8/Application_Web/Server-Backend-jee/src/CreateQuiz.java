import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ejb.EJB;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonValue;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

import bean.AdministrationLocal;
import entities.Course;
import entities.Question;
import entities.Quiz;
import com.fasterxml.jackson.core.type.TypeReference;


/**
 * Servlet implementation class CreateQuiz
 */
@WebServlet("/createQuiz")
public class CreateQuiz extends HttpServlet {
	private static final long serialVersionUID = 1L;
	@EJB
    private AdministrationLocal administration;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateQuiz() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// Check if there is a session and if the username can be found in the session
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("username") == null) {
	        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        response.setContentType("application/json");
	        ObjectMapper objectMapper = new ObjectMapper();
	        objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Unauthorized"));
	        return;
	    }
	    
	    StringBuilder requestBody = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                requestBody.append(line);
            }
        }

        // Parse the JSON body to get the username and password
        JsonObject jsonBody = Json.createReader(new StringReader(requestBody.toString())).readObject();

	    // Retrieve parameters from the JSON body
        int duration = jsonBody.getInt("duration");
        long groupId = (long) jsonBody.getInt("id");
        String title = jsonBody.getString("title");
        JsonArray questionsArray= jsonBody.getJsonArray("questions");
	    
	    // Validate parameters
	    if (duration == 0 || title == null || questionsArray == null) {
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        response.setContentType("application/json");
	        ObjectMapper objectMapper = new ObjectMapper();
	        objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Missing parameters"));
	        return;
	    }
	    
	    try {
	        
	        // Validate questions
	        if (questionsArray.isEmpty()) {
	            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	            response.setContentType("application/json");
	            ObjectMapper objectMapper = new ObjectMapper();
	            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "No questions provided"));
	            return;
	        }
	        
	        
	        
			Collection<Question> questions_prepared = new ArrayList<>();
	        // Process each question
	        for (JsonValue jsonValue : questionsArray) {
	        	JsonObject questionObject = (JsonObject) jsonValue;
	            String question = questionObject.getString("question");
	            List<String> choices = new ArrayList<>();
	            JsonArray choicesArray = questionObject.getJsonArray("choices");
	            for (JsonValue choiceValue : choicesArray) {
	                choices.add(choiceValue.toString());
	            }
	            String type = questionObject.getString("type");
	            List<String> correctAnswers = new ArrayList<>();
	            JsonArray correctAnswerArray = questionObject.getJsonArray("correctAnswer");
	            for (JsonValue correctAnswerValue : correctAnswerArray) {
	            	correctAnswers.add(correctAnswerValue.toString());
	            }
	            String correctAnswer = correctAnswers.get(0);

	            // Process each question and add it to the quiz
	            Question newQuestion = administration.createQuestion(question, correctAnswer, choices, type);
				questions_prepared.add(newQuestion);
	        }
	        System.out.println("HHHHHHHHHHH------------------3--------------hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
	        // Persist the new quiz
	        administration.createQuiz(title, duration, questions_prepared, groupId);

	        // Send success response
	        response.setStatus(HttpServletResponse.SC_CREATED);
	        response.setContentType("application/json");
	        ObjectMapper objectMapper = new ObjectMapper();
	        objectMapper.writeValue(response.getWriter(), Collections.singletonMap("message", "Quiz created successfully"));
	    } catch (NumberFormatException e) {
	        // Handle invalid number format
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        response.setContentType("application/json");
	        ObjectMapper objectMapper = new ObjectMapper();
	        objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Invalid number format"));
	    } catch (Exception e) {
	        // Handle any other exceptions
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.setContentType("application/json");
	        ObjectMapper objectMapper = new ObjectMapper();
	        objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Internal Server Error"));
	        e.printStackTrace(System.out);
	    }
	}

}
