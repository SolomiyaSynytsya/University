using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Threading;

namespace Loader
{
   public class Connect
    {
       private void ExecProc(object color)
        {
            string sqlExpression = "AddRandomData";
            using (SqlConnection connection =
            new SqlConnection(Config.connectionString))
            {              
                try
                {
                    Random rnd = new Random();
                    int ammount = rnd.Next(1, 10);
                    connection.Open();
                    for (var i = 0; i < ammount; i++)
                    {
                        SqlCommand command = new SqlCommand(sqlExpression, connection);
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        var result = command.ExecuteNonQuery();
                        Console.ForegroundColor = (ConsoleColor)color;
                        Console.WriteLine(result);
                    }                            
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
                Console.ReadLine();
            }
        }
        public void generateThreads()
        {        
            Thread first = new Thread(new ParameterizedThreadStart(ExecProc));
            Thread second = new Thread(new ParameterizedThreadStart(ExecProc));
            Thread third = new Thread(new ParameterizedThreadStart(ExecProc));
            Thread fourth = new Thread(new ParameterizedThreadStart(ExecProc));
            Thread fifth = new Thread(new ParameterizedThreadStart(ExecProc));
            first.Start(Config.colors[0]);
            second.Start(Config.colors[1]);
            third.Start(Config.colors[2]);
            fourth.Start(Config.colors[3]);
            fifth.Start(Config.colors[4]);
        }         
    }
}
