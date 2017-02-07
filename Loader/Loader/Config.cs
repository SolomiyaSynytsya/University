using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Loader
{
   public class Config
    {
       public static string connectionString =
           "Data Source=(local);Initial Catalog=University;"
           + "Integrated Security=true";
       public static List<ConsoleColor> colors = new List<ConsoleColor>()
            {
                ConsoleColor.Blue,
                ConsoleColor.Red,
                ConsoleColor.White,
                ConsoleColor.Green,
                ConsoleColor.Yellow
            };
    }
}
