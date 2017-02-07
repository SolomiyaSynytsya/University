using System;
using System.Data.SqlClient;

namespace Loader
{
    class TestStProcedures
    {
       public static void ExecProc(object color)
        {
            string sqlExpression = "AddStudent";
            using (SqlConnection connection =
            new SqlConnection(Config.connectionString))
            {
                try
                {
                    Random rnd = new Random();
                    int ammount = rnd.Next(1, 10);
                    connection.Open();
                        SqlCommand command = new SqlCommand(sqlExpression, connection);
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        SqlParameter idPar = new SqlParameter
                        {
                            ParameterName = "@Name",
                            Value = "Jane"
                        };
                        command.Parameters.Add(idPar);
                        SqlParameter namePar = new SqlParameter
                        {
                            ParameterName = "@Surname",
                            Value = "Doe"
                        };
                        command.Parameters.Add(namePar);
                        SqlParameter markPar = new SqlParameter
                        {
                            ParameterName = "@GroupId",
                            Value = 3
                        };
                        command.Parameters.Add(markPar);
                        var result = command.ExecuteNonQuery();
                        Console.ForegroundColor = (ConsoleColor)color;
                        Console.WriteLine(result);
                    }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
                Console.ReadLine();
            }
        }
    }
}
