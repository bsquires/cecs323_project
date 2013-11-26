import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;


public class DBapp {
protected String dbms = "mysql";
protected String serverName = "127.0.0.1";
protected String portNumber = "3306";
protected String dbName = "radio";
protected String userName =null;
protected String password = null;

	public Connection getConnection() throws SQLException
	{
		Scanner input = new Scanner(System.in);
		System.out.println("Please enter your username");
		userName = input.next();
		System.out.println("Please enter your password");
		password = input.next();
		
		Connection conn = null;
		Properties connectionProps = new Properties();
		connectionProps.put("user", this.userName);
		connectionProps.put("password", this.password);
		
		if(this.dbms.equals("mysql"))
		{
			conn = DriverManager.getConnection("jdbc:"+this.dbms+"://"
					+ this.serverName + ":" + this.portNumber + "/"+this.dbName,
					connectionProps);
			
		}
		else if (this.dbms.equals("derby")) {
	        conn = DriverManager.getConnection(
	                   "jdbc:" + this.dbms + ":" 
	                   + this.dbName +
	                   ";create=true",
	                   connectionProps);
	    }
		System.out.println("Connected to database");
		return conn;
	}
	public static void main(String[] args) throws SQLException {
	DBapp myApp = new DBapp();
	Connection myConnect = myApp.getConnection();

	}

}
