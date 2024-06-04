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




/**
 * Servlet implementation class groups
 */
@WebServlet("/groups")
public class Groups extends HttpServlet {
	@EJB
    private AdministrationLocal administration;
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Groups() {
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

        String username = (String) session.getAttribute("username");

        try {
            // Get the groups of the student using the AdministrationLocal bean
            Collection<Course> groups = administration.getCourses();
            
            // Prepare JSON response
            List<Map<String, Object>> jsonResponse = new ArrayList<>();
            for (Course group : groups) {
                Map<String, Object> groupMap = new HashMap<>();
                groupMap.put("id", group.getId());
                groupMap.put("title", group.getTitle());
                jsonResponse.add(groupMap);
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
