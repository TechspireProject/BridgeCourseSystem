using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace BridgePrep
{
    public partial class SelectQuiz : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Session check for Student (RoleId = 3)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 3)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadQuizzes();
            }
        }

        private void LoadQuizzes()
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserId"]);

                // Query to join Quizzes, Subjects, and calculate Student Attempts, Best Score, & Latest Score
                string query = @"
                    SELECT 
                        q.QuizId, 
                        q.QuizTitle, 
                        q.TotalMarks, 
                        s.SubjectName,
                        ISNULL(attempts.TotalAttempts, 0) AS TotalAttempts,
                        ISNULL(attempts.BestScore, 0) AS BestScore,
                        ISNULL(latest.Score, 0) AS LatestScore
                    FROM Quizzes q 
                    JOIN Subjects s ON q.SubjectId = s.SubjectId 
                    LEFT JOIN (
                        SELECT 
                            QuizId, 
                            COUNT(*) AS TotalAttempts, 
                            MAX(Score) AS BestScore
                        FROM Scores
                        WHERE StudentId = @StudentId
                        GROUP BY QuizId
                    ) attempts ON q.QuizId = attempts.QuizId
                    LEFT JOIN (
                        SELECT s1.QuizId, s1.Score
                        FROM Scores s1
                        INNER JOIN (
                            SELECT QuizId, MAX(TakenAt) AS MaxTaken
                            FROM Scores
                            WHERE StudentId = @StudentId
                            GROUP BY QuizId
                        ) s2 ON s1.QuizId = s2.QuizId AND s1.TakenAt = s2.MaxTaken
                        WHERE s1.StudentId = @StudentId
                    ) latest ON q.QuizId = latest.QuizId
                    ORDER BY q.QuizId DESC";

                SqlParameter[] parameters = {
                    new SqlParameter("@StudentId", studentId)
                };

                DataTable dt = DbHelper.ExecuteQuery(query, parameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvAvailableQuizzes.DataSource = dt;
                    gvAvailableQuizzes.DataBind();
                    lblNoQuizzes.Visible = false;
                }
                else
                {
                    gvAvailableQuizzes.DataSource = null;
                    gvAvailableQuizzes.DataBind();
                    lblNoQuizzes.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblNoQuizzes.Text = "Error loading quizzes: " + ex.Message;
                lblNoQuizzes.Visible = true;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}