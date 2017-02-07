using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Loader
{
    class Program
    {
        static void Main(string[] args)
        {
            // Connect UniversityDb = new Connect();
            //UniversityDb.generateThreads();
            TestStProcedures.ExecProc(Config.colors[0]);
        }
    }
}
