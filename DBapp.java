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
        public void queryMenu(Connection conn) throws SQLException
        {
        	//Create the menu
            System.out.println("Please select a query to execute.");
            boolean inputVal = false;
            String userInput= null;
            char choice =  ' ';
            
            while(!inputVal)
            {
                System.out.println("1: List all employees");
                System.out.println("2: List all shows");
                System.out.println("3: List all DJs");
                
                userInput = input.next();
                choice = userInput.charAt(0);
                switch(choice)
                {
                    /*
                    This is where we will call the query methods
                    */
                    case '1':
                        employeeDataQuery(conn);
                        inputVal=true;
                        break;
                    case '2':
                        showNameQuery(conn);
                        inputVal=true;
                        break;
                    case '3':
                        djNameQuery(conn);
                        inputVal=true;
                        break;
                    default:
                        System.out.println("Invalid input. Please try again");
                        break;
                        
                }
            
            }
            
        }//end queryMenu
        
        public void employeeDataQuery(Connection conn) throws SQLException
        {
            Statement stmt = null;
            queryStr = "SELECT Fname, Lname FROM " + dbName+ ".employees";
            try {
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(queryStr);
            //retrieve the results from the result set
            while(rs.next())
            {
                String employeeName = rs.getString("Fname");
                employeeName  += " " + rs.getString("Lname");
                System.out.println("Employee Name: " + employeeName);
            }
            } catch (SQLException e)
            {
            System.out.println(e.getMessage());
            }finally {
            if (stmt != null) { stmt.close(); }
             }//end catch
            
            
        }
        
        public void showNameQuery(Connection conn) throws SQLException
        {
            Statement stmt = null;
            String showName = null;
            queryStr = "SELECT name FROM " + dbName+ ".shows";
            try {
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(queryStr);
            //retrieve the results from the result set
            while(rs.next())
            {
                showName = rs.getString("name");
                System.out.println("Show Name: " + showName);
            }
            } catch (SQLException e)
            {
            System.out.println(e.getMessage());
            }finally {
            if (stmt != null) { stmt.close(); }
             }//end catch
            
            
        }//showNameQuery
        
        public void djNameQuery(Connection conn) throws SQLException
        {
            Statement stmt = null;
            String stageName = null;
            queryStr = "SELECT stageName FROM " + dbName+ ".djs";
            try {
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(queryStr);
            //retrieve the results from the result set
            while(rs.next())
            {
                stageName = rs.getString("stageName");
                System.out.println("DJ Name: " + stageName);
            }
            } catch (SQLException e)
            {
            System.out.println(e.getMessage());
            }finally {
            if (stmt != null) { stmt.close(); }
             }//end catch
            
            
        }//end djNameQuery
        
        public int getShowIDQuery(Connection conn, String showName) throws SQLException
        {
            Statement stmt = null;
            int showID = -1;
            queryStr = "SELECT shid  FROM " + dbName+ ".shows WHERE "
                    +"name = '"+showName+"'";
            try {
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(queryStr);
            //retrieve the results from the result set
            while(rs.next())
            {
                showID = rs.getInt("shid");
            }
            } catch (SQLException e)
            {
            System.out.println(e.getMessage());
            }finally {
            if (stmt != null) { stmt.close(); }
             }//end catch
            
            return showID;
        }//end djNameQuery
        
        
        
        //pass the active connection to the insert
        public void insertSpan(Connection conn) throws SQLException
        {
            Statement stmt = null;
            String hostingDJ = null;
            String startDate = null;
            String finishDate = null;
            String showName = null;
            String insertStr = null;
            int showID = -1;
            int rowsChanged = -1;
            
            //clear the buffer
            input.nextLine();
            
            //Get insertion information from user
            System.out.println("What show are you adding a span to?");
            System.out.println("Please carefully enter one of the following:\n");
            showNameQuery(conn);
            showName = input.nextLine();
            
            System.out.println("Which DJ will be hosting this span?");
            System.out.println("Please carefully enter one of the following:\n");
            djNameQuery(conn);
            hostingDJ = input.nextLine();
            
            System.out.println("When will this span start? (e.g. 2013-02-14");
            startDate = input.nextLine();
            
            System.out.println("When will this span end?");
            finishDate = input.nextLine();
            
            //Get shID from showName
            showID = getShowIDQuery(conn, showName);
            
            //Execute the Insert
            try {
                    //This is the SQL statement that will be executed
	            insertStr = "INSERT INTO " + dbName+ ".spans(stageName,beginDate,endDate, showName, shID)"+
	                          " VALUES('"+hostingDJ+"','"+startDate+"','"+finishDate+"','"+showName+"',"+showID+");";
                    
	            stmt = conn.createStatement();
	            rowsChanged = stmt.executeUpdate(insertStr);
	            
	            if(rowsChanged == 1) System.out.println("Show span succesfully added!");
	            else if(rowsChanged == 0) System.out.println("Something has gone wrong, no changes made!");
	            else System.out.println("Something weird has happened, more than one row has changed!");
	            
            }catch (SQLException e)
            {
                System.out.println("I can't insert that, Dave.");
                System.out.println(e.getMessage());
            }finally {
                if (stmt != null) { stmt.close(); }
            }//end catch
            
            
        }//end insertSpan
        
        public void confirmCommit(Connection conn) throws SQLException
        {
            //Check if the user wants to commit the changes
            boolean commits = false;
            
            try
            {
                while(!commits)
                {
                    System.out.println("Do you want to commit the changes made thus far?");
                    System.out.println("Press y for yes");
                    System.out.println("Press n for no");
                    System.out.println("Press r to rollback changes made so far");
                    String commString = input.next();
        
                    if(commString.equalsIgnoreCase("y"))
                    {
                        conn.commit();
                        commits=true;
                    }else if(commString.equalsIgnoreCase("n"))
                    {
                        commits = true;
                    }
                    else if(commString.equalsIgnoreCase("r"))
                    {
                        conn.rollback();
                        commits = true;
                    }
                    else
                    {
                        System.out.println("Invalid input. Please try again");
                    }//end commits conditionals
                }//end commit while
            }catch (SQLException e)
            {
                System.out.println("I can't insert that, Dave.");
                System.out.println(e.getMessage());
            }
        }//end commitConfirm
        public void deleteEmployee(Connection conn) throws SQLException
        {
            String confirmDelete = null;
            String empFname = null;
            String empLname = null;
            Statement stmt = null;
            input.nextLine();//clear the buffer
            System.out.println("If you delete an employee that is a DJ");
            System.out.println("that DJ name will remain, but will no longer");
            System.out.println("be associated with the employee that used that DJ name");
            System.out.println("Would you like to continue?");
            
            boolean valid = false;
            while(!valid)
            {
                confirmDelete = input.nextLine();
                if(confirmDelete.equals("y"))valid = true;
                else if(confirmDelete.equals("n")) return;
                else System.out.println("I'm sorry, Dave. But I can't do that."
                        + "\nChoose more carefully.");
            }
          
           System.out.println("Please carefully enter the first name of the employee you would like to remove\n");
           employeeDataQuery(conn);
           empFname = input.nextLine();
           System.out.println("Please carefully enter the last name of the employee you would like to remove\n");
           empLname = input.nextLine();
           
           queryStr = "DELETE FROM "+dbName+".employees WHERE Fname = '"
                   + empFname +"' AND Lname = '"+empLname+"'";
           
           try {
                stmt = conn.createStatement();
                int rowsAffected = stmt.executeUpdate(queryStr);
                if(rowsAffected == 1 ){System.out.println("SUCCESS!");}
            } catch (SQLException e)
            {
                System.out.println("I can't delete that, Dave.");
                System.out.println(e.getMessage());
            }finally {
                if (stmt != null) { stmt.close(); }
             }//end catch
        }
         //Insert into the employees table
        public void insertEmployees(Connection conn) throws SQLException
        {
            String fname = null;
            String lname = null;
            int salary = -1;
            String dob = null;
            String address = null;
            String zip = null;
            Statement stmt = null;
            
            input.nextLine();
            //prompt the user to enter the employee information
            System.out.println("Please enter the employee's first name");
            fname = input.nextLine();
            System.out.println("Please enter the employee's last name");
            lname = input.nextLine();
            System.out.println("Please enter employee salary");
            salary = input.nextInt();
            input.nextLine();//user NextLine to interpret the carriage return
            System.out.println("Please enter the dob in format yyyy-mm-dd");
            dob = input.nextLine();
            System.out.println("Please enter an address for the employee");
            address = input.nextLine();
            System.out.println("Please enter a zipcode");
            zip = input.nextLine();
            
            queryStr = "INSERT INTO "+dbName+ ".employees VALUES "
                    + "(NULL, '"+fname+"','"+lname+"','"+dob+"',"
                    +salary+",'"+address+"','"+zip+"')";
            /*
            Use these two linesof code to see your Query string:
            System.out.println("This is your Query String: ");
            System.out.println(queryStr);
            */
            try {
                stmt = conn.createStatement();
                int rowsAffected = stmt.executeUpdate(queryStr);
                if(rowsAffected == 1 ) System.out.println("SUCCESS!");
            } catch (SQLException e)
            {
                System.out.println("I can't insert that, Dave.");
                System.out.println(e.getMessage());
            }finally {
                if (stmt != null) { stmt.close(); }
             }//end catch
            
            
        }//end insertEmployees
        
        //BEGIN MAIN PROGRAM
	public static void main(String[] args) throws SQLException, ClassNotFoundException {
	DBapp myApp = new DBapp();
	Connection myConnect = myApp.getConnection();
        
        //Create the menu
        System.out.println("Please make a selection.");
        boolean inputVal = false;
        String userInput= null;
        char choice =  ' ';
        
        while(!inputVal)
        {
            System.out.println("1: Execute a Query");
            System.out.println("2: to enter a new employee");
            System.out.println("3: to enter a new span");
            System.out.println("4: to delete an employee");
            System.out.println("5: to roll back changes made");
            System.out.println("q: Quit program");
            
            userInput = input.next();
            choice = userInput.charAt(0);
            switch(choice)
            {
                /*
                This is where we will call the update and query methods
                */
                case '1':
                    myApp.queryMenu(myConnect);
                    inputVal=true;
                    break;
                case '2':
                    myApp.insertEmployees(myConnect);
                    myApp.confirmCommit(myConnect);
                    inputVal=true;
                    break;
                case '3':
                    myApp.insertSpan(myConnect);
                    myApp.confirmCommit(myConnect);
                    inputVal=true;
                    break;
                case '4':
                    myApp.deleteEmployee(myConnect);
                    myApp.confirmCommit(myConnect);
                    inputVal=true;
                    break;
                case '5':
                    myConnect.rollback();
                    break;
                case 'q':
                	inputVal=true;
                	break;
                default:
                    System.out.println("Invalid input. Please try again");
                    break;
                    
            }
        
        }
   
        
        myConnect.close();
	}

}
