package javaPackage;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;

public class Database {
	private static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	private static final String url = "jdbc:mysql://localhost:3306/HarvesTree";
	private static final String user = "root";
	private static final String pass = "password";
	
	public Connection connect (){
    Connection con = null;

		try{
			Class.forName(JDBC_DRIVER);
			con = DriverManager.getConnection(url, user, pass);
		}
		catch (ClassNotFoundException | SQLException e){
			e.printStackTrace();
		}
    
    return con;
	}
}
