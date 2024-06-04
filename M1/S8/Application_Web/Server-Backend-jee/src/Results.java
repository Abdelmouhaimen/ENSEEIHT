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
import entities.Response;
import entities.Student;

@WebServlet("/results")
public class Results extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private AdministrationLocal administration;

    public Results() {
        super();
    }

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

        // Retrieve the quiz ID from the request parameters
        String quizIdString = request.getParameter("id");
        if (quizIdString == null || quizIdString.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Missing quiz ID"));
            return;
        }

        // Parse the quiz ID string to a Long
        Long quizId;
        try {
            quizId = Long.parseLong(quizIdString);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Invalid quiz ID"));
            return;
        }

        try {
            // Get the quiz responses using the AdministrationLocal bean
            Collection<Response> responses = administration.getResponsesByQuizId(quizId);

            // Prepare JSON response
            List<Map<String, Object>> resultsJson = new ArrayList<>();
            for (Response r : responses) {
                Map<String, Object> resultMap = new HashMap<>();
                Student student = r.getStudent();
                resultMap.put("student", student.getUsername());
                resultMap.put("score", r.getScore());
                resultsJson.add(resultMap);
            }

            // Send JSON response
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), resultsJson);
        } catch (Exception e) {
            // Handle any exceptions that might occur
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(response.getWriter(), Collections.singletonMap("error", "Internal Server Error"));
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}