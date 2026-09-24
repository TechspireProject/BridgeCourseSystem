using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace BridgePrep
{
    public class DbHelper
    {
        private static readonly string connStr = ConfigurationManager.ConnectionStrings["BridgePrepConn"].ConnectionString;

        /// <summary>
        /// Execute INSERT, UPDATE, DELETE queries
        /// </summary>
        public static int ExecuteNonQuery(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        foreach (SqlParameter p in parameters)
                        {
                            // Clone parameter to prevent "Parameter already contained by another collection" error
                            cmd.Parameters.Add((ICloneable)p != null ? ((ICloneable)p).Clone() : p);
                        }
                    }

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    cmd.Parameters.Clear();
                    return rowsAffected;
                }
            }
        }

        /// <summary>
        /// Execute SELECT queries and return DataTable
        /// </summary>
        public static DataTable ExecuteQuery(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        foreach (SqlParameter p in parameters)
                        {
                            // Clone parameter to prevent "Parameter already contained by another collection" error
                            cmd.Parameters.Add((ICloneable)p != null ? ((ICloneable)p).Clone() : p);
                        }
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        cmd.Parameters.Clear();
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// Execute scalar queries (e.g., SELECT COUNT(*)) returning a single value
        /// </summary>
        public static object ExecuteScalar(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        foreach (SqlParameter p in parameters)
                        {
                            cmd.Parameters.Add((ICloneable)p != null ? ((ICloneable)p).Clone() : p);
                        }
                    }

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    cmd.Parameters.Clear();
                    return result;
                }
            }
        }
    }
}