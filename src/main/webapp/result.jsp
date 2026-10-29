
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Booking Details</title>
</head>
<body>

<h2>Photo Studio Booking Details</h2>

<%
String client = request.getParameter("client");
String event = request.getParameter("event_type");
String totalStr = request.getParameter("total_amt");
String advanceStr = request.getParameter("advance");

if (client == null || event == null ||
    totalStr == null || advanceStr == null) {

    out.println("Please submit the booking form first.");

} else {
    try {
        int total = Integer.parseInt(totalStr);
        int advance = Integer.parseInt(advanceStr);

        if (client.trim().isEmpty() ||
            total < 0 || advance < 0 || advance > total) {

            out.println("Invalid booking details!");

        } else {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/photo_studio",
                "root", "root")) {

                String sql = "INSERT INTO photo_booking " +
                    "(client, event_type, total_amt, advance) " +
                    "VALUES (?, ?, ?, ?)";

                try (PreparedStatement ps =
                    con.prepareStatement(sql)) {

                    ps.setString(1, client.trim());
                    ps.setString(2, event);
                    ps.setInt(3, total);
                    ps.setInt(4, advance);
                    ps.executeUpdate();
                }

                out.println("<p>Booking saved successfully!</p>");
%>

<table border="1" cellpadding="8">
<tr>
    <th>ID</th>
    <th>Client Name</th>
    <th>Event Type</th>
    <th>Total Amount</th>
    <th>Advance</th>
    <th>Balance</th>
</tr>

<%
                String query =
                    "SELECT * FROM photo_booking ORDER BY id";

                try (Statement st = con.createStatement();
                     ResultSet rs = st.executeQuery(query)) {

                    while (rs.next()) {
                        int balance =
                            rs.getInt("total_amt")
                            - rs.getInt("advance");
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("client") %></td>
    <td><%= rs.getString("event_type") %></td>
    <td><%= rs.getInt("total_amt") %></td>
    <td><%= rs.getInt("advance") %></td>
    <td><%= balance %></td>
</tr>

<%
                    }
                }
%>
</table>

<%
            }
        }
    } catch (NumberFormatException e) {
        out.println("Please enter valid amounts.");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>

<br>
<a href="index.html">Back to Booking Form</a>

</body>
</html>
