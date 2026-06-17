class DashboardController < ApplicationController
  before_action :authenticate_user! # remova esta linha se quiser a home pública

  def show
    # NOTE: estes dados são fictícios para fins de layout.
    # Quando tiver um model Profile (ou usar o próprio current_user),
    # troque este OpenStruct por algo como: @profile = current_user.profile
    @profile = OpenStruct.new(
      name: current_user&.full_name || "Caroline Belfort",
      headline: "Station Oaklnont",
      initials: (current_user&.full_name || "Caroline Belfort").split.map(&:first).first(2).join.upcase,
      connections_count: 358,
      views_count: 25,
      links: [
        { label: "linkedin.com/carolinebelfort", url: "#" },
        { label: "carolinebelfort", url: "#" },
        { label: "carolinebelfort", url: "#" }
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
  end
end