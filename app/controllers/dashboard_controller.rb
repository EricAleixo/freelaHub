class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @profile = OpenStruct.new(
      name: current_user&.full_name || "Caroline Belfort",
      headline: current_user&.profile.headline || "",
      initials: (current_user&.full_name || "Caroline Belfort").split.map(&:first).first(2).join.upcase,
      connections_count: 358,
      views_count: 25,
      links: [
        { label: current_user&.profile.linkedin, url: current_user&.profile.linkedin },
        { label: current_user&.profile.github, url: current_user&.profile.github },
      ],
      showreels: [
        { title: "Showreel 2015" },
        { title: "Showreel 2014" }
      ],
      summary: "Novitates autem si spem adferunt, ut tamquam in herbis non fallacibus " \
                "fructus apparent, non sunt illae quidem repudiandae, sed tamen sunt " \
                "loco conservanda, maxima vel enim vel vetustas et consuetudo.",
      experiences: [
        {
          role: "Cabin crew world manager",
          company: "British Airways",
          period: "March 1990 - Present (16 year 3 months)",
          description: "Novitates autem si spem adferunt, ut tamquam in herbis non " \
                        "fallacibus fructus apparent, non sunt illae quidem repudiandae.",
          initials: "BA",
          badge_color: "bg-slate-900"
        },
        {
          role: "Human resource director",
          company: "Ulysse corp",
          period: "Jan 1985 - Feb 1990 (5 years)",
          description: "Novitates autem si spem adferunt, ut tamquam in herbis non fallacibus.",
          initials: "UC",
          badge_color: "bg-orange-500"
        }
      ],
      stats: { views: 25, visitors: 15 },
      similar_profile: { name: "Cynthia Aurele", role: "Project manager", initials: "CA" }
    )

    @posts = Post.joins(:attachments_attachments).distinct.limit(2)
    @jobs = Job.where.not(user_id: current_user.id).where.not(id: Proposal.where(profile_id: current_user.profile.id).select(:job_id))
    @similar_profiles = Profile.where.not(user_id: current_user.id)
    @profile_views = ProfileView.where(viewed_id: current_user.profile.id).count
    @profile_skills = current_user.profile.skills
  end
end