using System;
using System.Diagnostics;
using System.IO;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using System.Linq;

namespace EmacsRunner
{
    static class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            var emacs_home = Environment.GetEnvironmentVariable("EMACS_HOME");
            if (emacs_home == null)
            {
                MessageBox.Show("EMACS_HOME envirnoment variable not set", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if (!emacs_home.EndsWith("/") && !emacs_home.EndsWith("\\")) emacs_home += "\\";
            var runemacs = emacs_home + "bin\\runemacs.exe";
            if (!File.Exists(runemacs))
            {
                MessageBox.Show("%EMACS_HOME%\\bin\\runemacs.exe (expanded to " + runemacs + ") does not exist", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            var arg0 = args.Length == 0 ? null : args[0];
            if (arg0 != null)
            {
                if (Regex.IsMatch(arg0, @"^\w+$"))
                {
                    var home = Environment.GetEnvironmentVariable("USERPROFILE");
                    if (home != null && !home.EndsWith("/") && !home.EndsWith("\\")) home += "\\";
                    var dotemacs = home + ".emacs.d\\";
            
                    var desktop_home = dotemacs + "desktops\\" + arg0 + "\\";
                    if (!Directory.Exists(desktop_home))
                    {
                        MessageBox.Show("%USERPROFILE%\\.emacs.d\\desktops\\" + arg0 + " (expanded to " + desktop_home + ") does not exist", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }

                    Environment.SetEnvironmentVariable("EMACS_DESKTOP", arg0);
                    args = args.Skip(1).ToArray();

                    Func<String, bool> is_reg = s => 
                        String.Compare(s, "/reg", StringComparison.InvariantCultureIgnoreCase) == 0 ||
                        String.Compare(s, "/register", StringComparison.InvariantCultureIgnoreCase) == 0;
                    if (args.Any(is_reg))
                    {
                        var current_el = dotemacs + "desktops\\" + "current.el";
                        File.WriteAllText(current_el, String.Format("(setq my-current-desktop \"{0}\")", arg0));
                        args = args.Where(s => !is_reg(s)).ToArray();
                    }
                }

                if (arg0.StartsWith("\\"))
                {
                    arg0 = arg0.Substring(1);
                    args[0] = arg0;
                }
            }

            args = Enumerable.Concat(args, new[] {"-xrm", "Emacs.FontBackend:gdi"}).ToArray();
            Process.Start(runemacs, String.Join(" ", args));
        }
    }
}
