import java.sql.*;
import java.util.Scanner;

public class database_exp2 {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/orderdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASSWORD = "YYGDF0625";

    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        Class.forName(JDBC_DRIVER);
        Connection connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);
        Statement statement = connection.createStatement();
        if (connection == null) {
            System.out.println("连接失败");
        } else {
            System.out.println("连接成功");
            /* BEGIN Q4.1 */
            String sql_4_1 = " select employeeNo, employeeName, salary from employee order by salary desc limit 20;";
            ResultSet resultSet_4 = statement.executeQuery(sql_4_1);
            System.out.println("employeeNo\temployeeName\tsalary");
            while (resultSet_4.next()) {
                String emplyeeNo = resultSet_4.getString("employeeNo");
                String employeeName = resultSet_4.getString("employeeName");
                Float salary = resultSet_4.getFloat("salary");
                System.out.printf("%-15s%-10s%.2f\n", emplyeeNo, employeeName, salary);
            }
            /* END Q4.1 */
            /* BEGIN Q4.2 */
            String sql_4_2 = "insert Customer values('C20080002','泰康股份有限公司','010-5422685','天津市','220501');";
            if (statement.executeUpdate(sql_4_2) >= 1) {
                System.out.println("添加成功");
            } else {
                System.out.println("添加失败");
            }
            /* END Q4.2 */

            /* BEGIN Q4.3 */
            String sql_4_3 = "delete from employee where salary > 5000;";
            if (statement.executeUpdate(sql_4_3) >= 1) {
                System.out.println("删除成功");
            } else {
                System.out.println("删除失败");
            }
            /* END Q4.3 */
            /* BEGIN Q4.4 */
            String sql_4_4 = "update product set productPrice = 0.5 * productPrice where productPrice > 1000;";
            if (statement.executeUpdate(sql_4_4) >= 1) {
                System.out.println("更新成功");
            } else {
                System.out.println("更新失败");
            }
            /* END Q4.4 */
            /* BEGIN Q5.1 */
            System.out.print("请输入部门名：");
            Scanner scanner = new Scanner(System.in);
            String department = scanner.next();
            PreparedStatement preparedStatement = connection.prepareStatement("update employee set salary = salary + 200 where department = (?)");
            preparedStatement.setString(1, department);
            if (preparedStatement.executeUpdate() >= 1) {
                System.out.println("更新成功");
            } else {
                System.out.println("更新失败");
            }
            /* END Q5.1 */
            /* BEGIN Q5.2 */
            String sql_5_2 = " select customerName, address, telephone from customer;";
            preparedStatement = connection.prepareStatement(sql_5_2, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
            preparedStatement.setFetchSize(Integer.MIN_VALUE);
            preparedStatement.setFetchDirection(ResultSet.FETCH_REVERSE);
            ResultSet resultSet_5 = preparedStatement.executeQuery();
            System.out.println("customerName\t\taddress\t\ttelephone");
            while (resultSet_5.next()) {
                String customerName = resultSet_5.getString("customerName");
                String address = resultSet_5.getString("address");
                String telephone = resultSet_5.getString("telephone");
                System.out.printf("%-15s %-8s %-15s\n", customerName, address, telephone);
            }
            /* END Q5.2 */
            connection.close();
        }
    }
}
