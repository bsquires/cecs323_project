import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;
import java.sql.*;

public class DBapp {
protected String dbms = "mysql";
protected String serverName = "127.0.0.1";
protected String portNumber = "3306";
protected String dbName = "radio";
protected String userName =null;
protected String password = null;
protected String queryStr = null;
protected Connection conn= null;
protected static Scanner input = new Scanner(System.in);
        //This method establishes the connection
	public Connection getConnection() throws SQLException, ClassNotFoundException
	{
            
                //load the MySQL driver (connector J jar file)
                Class.forName("com.mysql.jdbc.Driver");
                //get username for the database
		System.out.println("Please enter your username");
		userName = input.next();
                //get password for the database
		System.out.println("Please enter your password");
		password = input.next();
		
                //Create a connection object
		Connection conn = null;
                
                //set the username and password as the connection
                //properties
		Properties connectionProps = new Properties();
		connectionProps.put("user", this.userName);
		connectionProps.put("password", this.password);
		
                //establish a connection to a mysql database
		if(this.dbms.equals("mysql"))
		{
			conn = DriverManager.getConnection("jdbc:"+this.dbms+"://"
					+ this.serverName + ":" + this.portNumber + "/"+this.dbName,
					connectionProps);
			
		}//end mysql if
		else if (this.dbms.equals("derby")) {
	        conn = DriverManager.getConnection(
	                   "jdbc:" + this.dbms + ":" 
	                   + this.dbName +
	                   ";create=true",
	                   connectionProps);
	    }//end derby elseif
		System.out.println("Connected to database");
                //prevent MySQL auto-commits
                conn.setAutoCommit(false);
		return conn;
	}//end getConnection() method
        
        //pass the active connection to the query
        public void prepQuery1(Connection conn) throws SQLException
        {
            Statement stmt = null;
            queryStr = "SELECT * FROM " + dbName+ ".artists";
            try {
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(queryStr);
            //retrieve the results from the result set
            while(rs.next())
            {
                String artistName = rs.getString("Fname");
                artistName  += " " + rs.getString("Lname");
                System.out.println("Artist Name: " + artistName);
            }
            } catch (SQLException e)
            {
            System.out.println("Exception :(");
            }finally {
            if (stmt != null) { stmt.close(); }
             }//end catch
            
            
        }//end prepQuery1
        
                //pass the active connection to the insert
        public void insertSpan(Connection conn) throws SQLException
        {
            Statement stmt = null;
            String hostingDJ = null;
            String startDate = null;
            String finishDate = null;
            String showName = null;
            int showID = -1;
            String g
            
            //Get insertion information from user
            System.out.println("What show are you adding a span to?"); //User only knows show by name, not ID
            showName = input.next();
            
            System.out.println("Which DJ will be hosting this span?");
            hostingDJ = input.next();
            
            System.out.println("When will this span start? (e.g. 2013-02-14");
            startDate = input.next();
            
            System.out.println("When will this span end?");
            finishDate = input.next();
            
            //This is the SQL statement that will be executed
            String insertStr = "INSERT INTO " + dbName+ ".spans(stageName,beginDate,endDate,shID)"+
                                "VALUES('"+hostingDJ+"','"+startDate+"','"+finishDate+"','"+showID;
            try {
            stmt = conn.createStatement();
            int rowsChanged = stmt.executeUpdate(queryStr); //should be 1 if successful
            
            if(rowsChanged == 1) System.out.println("Span succesfully added!")
            else if(rowsChanged == 0) System.out.println("Something has gone wrong, no changes made!")
            else System.out.println("Something weird has happened, more than one row has changed!");
            
            }catch (SQLException e){
                System.out.println("Exception :(");
            }finally {
                if (stmt != null) { stmt.close(); }
            }//end catch
            
            
        }//end insertSpan
        
	public static void main(String[] args) throws SQLException, ClassNotFoundException {
	DBapp myApp = new DBapp();
	Connection myConnect = myApp.getConnection();
        
        //Create the menu
        System.out.println("Pleaes make a selection.");
        boolean inputVal = false;
        String userInput= null;
        char choice =  ' ';
        
        while(!inputVal)
        {
            System.out.println("1: for query1");
            System.out.println("2: for query2");
            System.out.println("3: for query3");
            System.out.println("4: for query4");
            
            userInput = input.next();
            choice = userInput.charAt(0);
            switch(choice)
            {
                /*
                This is where we will call the update and query methods
                */
                case '1':
                    myApp.prepQuery1(myConnect);
                    inputVal=true;
                    break;
                case '2':
                    myApp.prepQuery1(myConnect);
                    inputVal=true;
                    break;
                case '3':
                    myApp.prepQuery1(myConnect);
                    inputVal=true;
                    break;
                case '4':
                    myApp.prepQuery1(myConnect);
                    inputVal=true;
                    break;
                default:
                    System.out.println("Invalid input. Please try again");
                    break;
                    
            }
        
        }
        //myConnect.commitChanges();
        myConnect.close();

	}

}
