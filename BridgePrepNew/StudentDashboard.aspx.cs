using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace BridgePrep
{
    public partial class StudentDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            try
            {
                string userId = Session["UserId"].ToString();
                string selectedSubject = Request.QueryString["subject"];

                // 1. Load User Profile Name
                string userQuery = "SELECT FullName FROM Users WHERE UserId = @UserId";
                SqlParameter[] userParams = { new SqlParameter("@UserId", userId) };
                DataTable userDt = DbHelper.ExecuteQuery(userQuery, userParams);

                if (userDt != null && userDt.Rows.Count > 0)
                {
                    lblUserName.Text = userDt.Rows[0]["FullName"].ToString();
                }

                // 2. Load Dynamic Subject Cards
                LoadSubjects();

                // 3. Load Learning Progress Bar
                LoadLearningProgress(userId, selectedSubject);

                // 4. Load Available Quizzes
                LoadAvailableQuizzes(selectedSubject);

                // 5. Load Recent Quiz Submissions
                LoadRecentAttempts(userId, selectedSubject);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Dashboard Error: " + ex.Message);
            }
        }

        private void LoadSubjects()
        {
            string query = "SELECT SubjectId, SubjectName FROM Subjects ORDER BY SubjectName ASC";
            DataTable dtSubjects = DbHelper.ExecuteQuery(query, new SqlParameter[0]);

            if (dtSubjects != null && dtSubjects.Rows.Count > 0)
            {
                rptSubjects.DataSource = dtSubjects;
                rptSubjects.DataBind();
            }
        }

        private void LoadLearningProgress(string userId, string selectedSubject)
        {
            try
            {
                // Total Quizzes Count (filtered by subject if selected)
                string totalQuizQuery = string.IsNullOrEmpty(selectedSubject)
                    ? "SELECT COUNT(*) FROM Quizzes"
                    : @"SELECT COUNT(*) FROM Quizzes q JOIN Subjects s ON q.SubjectId = s.SubjectId WHERE s.SubjectName = @SubjectName";

                SqlParameter[] totalParams = string.IsNullOrEmpty(selectedSubject)
                    ? new SqlParameter[0]
                    : new SqlParameter[] { new SqlParameter("@SubjectName", selectedSubject) };

                DataTable dtTotal = DbHelper.ExecuteQuery(totalQuizQuery, totalParams);
                int totalQuizzes = (dtTotal != null && dtTotal.Rows.Count > 0 && dtTotal.Rows[0][0] != DBNull.Value) ? Convert.ToInt32(dtTotal.Rows[0][0]) : 0;

                // Completed Distinct Quizzes by User using Scores table
                string completedQuery = string.IsNullOrEmpty(selectedSubject)
                    ? "SELECT COUNT(DISTINCT QuizId) FROM Scores WHERE StudentId = @UserId"
                    : @"SELECT COUNT(DISTINCT sc.QuizId) FROM Scores sc JOIN Quizzes q ON sc.QuizId = q.QuizId JOIN Subjects s ON q.SubjectId = s.SubjectId WHERE sc.StudentId = @UserId AND s.SubjectName = @SubjectName";

                SqlParameter[] completedParams = string.IsNullOrEmpty(selectedSubject)
                    ? new SqlParameter[] { new SqlParameter("@UserId", userId) }
                    : new SqlParameter[] { new SqlParameter("@UserId", userId), new SqlParameter("@SubjectName", selectedSubject) };

                DataTable dtCompleted = DbHelper.ExecuteQuery(completedQuery, completedParams);
                int completedQuizzes = (dtCompleted != null && dtCompleted.Rows.Count > 0 && dtCompleted.Rows[0][0] != DBNull.Value) ? Convert.ToInt32(dtCompleted.Rows[0][0]) : 0;

                lblCompletedCount.Text = completedQuizzes.ToString();
                lblTotalQuizzesCount.Text = totalQuizzes.ToString();

                double percentage = 0;
                if (totalQuizzes > 0)
                {
                    percentage = Math.Min(100.0, Math.Round(((double)completedQuizzes / totalQuizzes) * 100.0, 1));
                }

                progressBarFill.Style["width"] = percentage + "%";
                progressBarFill.InnerText = percentage + "%";
                progressBarFill.Attributes["aria-valuenow"] = percentage.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Progress Error: " + ex.Message);
            }
        }

        private void LoadAvailableQuizzes(string selectedSubject)
        {
            string query = string.IsNullOrEmpty(selectedSubject)
                ? @"SELECT q.QuizId, 
                           COALESCE(q.QuizTitle, q.Title) AS QuizTitle, 
                           ISNULL(s.SubjectName, 'General') AS SubjectName, 
                           q.TotalMarks 
                    FROM Quizzes q LEFT JOIN Subjects s ON q.SubjectId = s.SubjectId 
                    ORDER BY q.QuizId DESC"
                : @"SELECT q.QuizId, 
                           COALESCE(q.QuizTitle, q.Title) AS QuizTitle, 
                           s.SubjectName, 
                           q.TotalMarks 
                    FROM Quizzes q JOIN Subjects s ON q.SubjectId = s.SubjectId 
                    WHERE s.SubjectName = @SubjectName 
                    ORDER BY q.QuizId DESC";

            SqlParameter[] parameters = string.IsNullOrEmpty(selectedSubject)
                ? new SqlParameter[0]
                : new SqlParameter[] { new SqlParameter("@SubjectName", selectedSubject) };

            DataTable dt = DbHelper.ExecuteQuery(query, parameters);

            if (dt != null && dt.Rows.Count > 0)
            {
                gvQuizzes.DataSource = dt;
                gvQuizzes.DataBind();
                gvQuizzes.Visible = true;
                lblNoQuizzes.Visible = false;
            }
            else
            {
                gvQuizzes.Visible = false;
                lblNoQuizzes.Visible = true;
                lblNoQuizzes.Text = string.IsNullOrEmpty(selectedSubject)
                    ? "No active quizzes available."
                    : $"No active quizzes available for {selectedSubject}.";
            }
        }

        private void LoadRecentAttempts(string userId, string selectedSubject)
        {
            string safeQuery = string.IsNullOrEmpty(selectedSubject)
                ? @"SELECT TOP 5 COALESCE(q.QuizTitle, q.Title) AS QuizTitle, 
                             ISNULL(s.SubjectName, 'General') AS SubjectName, 
                             sc.Score, sc.TotalMarks, sc.TakenAt 
                     FROM Scores sc 
                     JOIN Quizzes q ON sc.QuizId = q.QuizId 
                     LEFT JOIN Subjects s ON q.SubjectId = s.SubjectId 
                     WHERE sc.StudentId = @UserId 
                     ORDER BY sc.TakenAt DESC"
                : @"SELECT TOP 5 COALESCE(q.QuizTitle, q.Title) AS QuizTitle, 
                             s.SubjectName, 
                             sc.Score, sc.TotalMarks, sc.TakenAt 
                     FROM Scores sc 
                     JOIN Quizzes q ON sc.QuizId = q.QuizId 
                     JOIN Subjects s ON q.SubjectId = s.SubjectId 
                     WHERE sc.StudentId = @UserId AND s.SubjectName = @SubjectName 
                     ORDER BY sc.TakenAt DESC";

            SqlParameter[] parameters = string.IsNullOrEmpty(selectedSubject)
                ? new SqlParameter[] { new SqlParameter("@UserId", userId) }
                : new SqlParameter[] { new SqlParameter("@UserId", userId), new SqlParameter("@SubjectName", selectedSubject) };

            DataTable dt = DbHelper.ExecuteQuery(safeQuery, parameters);

            if (dt != null && dt.Rows.Count > 0)
            {
                gvRecentAttempts.DataSource = dt;
                gvRecentAttempts.DataBind();
                gvRecentAttempts.Visible = true;
                lblNoAttempts.Visible = false;
            }
            else
            {
                gvRecentAttempts.Visible = false;
                lblNoAttempts.Visible = true;
                lblNoAttempts.Text = string.IsNullOrEmpty(selectedSubject)
                    ? "No quizzes completed yet."
                    : $"No recent attempts found for {selectedSubject}.";
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