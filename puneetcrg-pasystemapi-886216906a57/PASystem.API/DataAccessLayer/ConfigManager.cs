using System.Data.SqlClient;
using System.Configuration;

namespace PASystem.API.Configuration
{
    /// <summary>
    /// Summary description for ConfigManager.
    /// Created by: Manpreet Singh
    /// </summary>
    class ConfigManager {

		public static SqlConnection GetNewSqlConnection 
		{
            get 
            {
                string cs=ConfigurationManager.ConnectionStrings["PASystem"].ConnectionString;
                return new SqlConnection(cs); 
            }
		}

        

	}
}
