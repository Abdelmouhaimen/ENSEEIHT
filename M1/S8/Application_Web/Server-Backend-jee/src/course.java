

import java.io.IOException;
import java.util.ArrayList;
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
import entities.Course;
import entities.Quiz;

/**
 * Servlet implementation class course
 */
@WebServlet("/course")
public class course extends HttpServlet {
	@EJB
	private AdministrationLocal administration;
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public course() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        String courseIdString = request.getParameter("id");
        if (courseIdString == null || courseIdString.isEmpty()) {
        	response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Parse the course ID string to a Long
        Long courseId = Long.parseLong(courseIdString);

        try {
        	// Retrieve quizzes for the course
        	Collection<Quiz> quizzes;
        	if (session.getAttribute("userType").equals("PROFESSOR")) {
                quizzes = administration.getQuizzes(courseId);
            } else {
                quizzes = administration.getQuizzes(courseId, session.getAttribute("username").toString());
            }
            // Prepare JSON response
            List<Map<String, Object>> jsonResponse = new ArrayList<>();
            for (Quiz quiz : quizzes) {
                Map<String, Object> quizMap = new HashMap<>();
                quizMap.put("id", quiz.getId());
                quizMap.put("title", quiz.getTitre());
                jsonResponse.add(quizMap);
            }

            // Send JSON response
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), jsonResponse);
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
