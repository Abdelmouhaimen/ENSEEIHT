

import java.io.IOException;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.AdministrationLocal;
import entities.User;

import javax.json.Json;
import javax.json.JsonObject;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.StringReader;

/**
 * Servlet implementation class Auth
 */
@WebServlet("/Auth")
public class Auth extends HttpServlet {
	@EJB
    private AdministrationLocal administration;
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Auth() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Check if the user session exists
	    HttpSession session = request.getSession(false);
	    if (session != null && session.getAttribute("username") != null) {
	        // Session exists, send session information to the frontend
	        JsonObject jsonResponse = Json.createObjectBuilder()
	                .add("username", session.getAttribute("username").toString())
	                .add("userType", session.getAttribute("userType").toString())
	                .build();

	        // Set response headers and write JSON response
	        response.setContentType("application/json");
	        try (PrintWriter out = response.getWriter()) {
	            out.println(jsonResponse.toString());
	        }
	    } else {
	        // Session doesn't exist or user not logged in, send empty response
	        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	    }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Read the JSON request body and parse it into a Credentials object
		// Read the JSON body of the request
        StringBuilder requestBody = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                requestBody.append(line);
            }
        }

        // Parse the JSON body to get the username and password
        JsonObject jsonBody = Json.createReader(new StringReader(requestBody.toString())).readObject();
        String username = jsonBody.getString("username");
        String password = jsonBody.getString("password");

        // Authenticate user
        User user = administration.authenticate(username, password);

        if (user != null) {
        	// Remember session by storing user data in HttpSession
            HttpSession session = request.getSession(true);
            session.setAttribute("username", username);
            session.setAttribute("userType", user.getType());
            
        } else {
            // Authentication failed, send 401 Unauthorized status
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
	}

}
