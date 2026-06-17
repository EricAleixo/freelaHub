module ProfilesHelper
  def field_classes(record, attribute, with_icon: false)
    base = "w-full py-2.5 border rounded-xl text-sm text-slate-900 placeholder-slate-400 " \
           "bg-slate-50 focus:outline-none focus:ring-2 focus:bg-white transition"
 
    padding = with_icon ? "pl-10 pr-3.5" : "px-3.5"
 
    state = if record.errors[attribute].any?
              "border-red-300 focus:ring-red-200 focus:border-red-400"
            else
              "border-slate-200 focus:ring-indigo-200 focus:border-indigo-400"
            end
 
    "#{base} #{padding} #{state}"
  end
end
