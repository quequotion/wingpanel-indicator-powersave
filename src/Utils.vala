/*
 * Wingpanel CPU frequency indicator
 * Copyright (c) 2018-2020 Dirli <litandrej85@gmail.com>
 *
 * Wingpanel Powersave indicator
 * Copyright (c) 2022-2022 Que Quotion <quequotion@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace Powersave {
    public class Utils {
        public static bool can_manage () {
            return GLib.FileUtils.test (CPU_PATH + "cpu0/cpufreq", FileTest.IS_DIR);
        }

        public static void set_turbo_boost (bool state) {
            string state_str = state ? "0" : "1";
            string def_boost = Utils.get_content (CPU_PATH + "intel_pstate/no_turbo");

            if (def_boost != state_str && Utils.get_permission ().allowed) {
                string cli_cmd = @"-t $(state ? "on" : "off")";

                Utils.run_cli (cli_cmd);
            }
        }

        public static string get_governor () {
            return Utils.get_content (CPU_PATH + "cpu0/cpufreq/scaling_governor");
        }

        public static void set_governor (string governor) {
            string def_governor = Utils.get_governor ();

            if (governor != "" && def_governor != governor) {
                string cli_cmd = " -g " + governor;
                Utils.run_cli (cli_cmd);
            }
        }

        public static void set_ht (bool state) {
            string state_str = state ? "0" : "1";
            string def_ht = Utils.get_content (CPU_PATH + "smt/control");

            if (def_ht != state_str && Utils.get_permission ().allowed) {
                string cli_cmd = @"-h $(state ? "on" : "off")";

                Utils.run_cli (cli_cmd);
            }
        }

        public static void set_gpu (bool state) {
            string state_str = state ? "0" : "1";
            //string def_boost = Utils.get_content (CPU_PATH + "intel_pstate/no_turbo");

            //if (def_gpu != state_str && Utils.get_permission ().allowed) {
                string cli_cmd = @"-v $(state ? "on" : "off")";

                Utils.run_cli (cli_cmd);
            //}
        }

        public static void set_sw (bool state) {
            string state_str = state ? "0" : "1";
            //string def_sw = Utils.get_content (CPU_PATH + "intel_pstate/no_turbo");

            //if (def_sw != state_str && Utils.get_permission ().allowed) {
                string cli_cmd = @"-s $(state ? "on" : "off")";

                Utils.run_cli (cli_cmd);
            //}
        }

        public static string get_content (string file_path) {
            string content;

            if (!GLib.FileUtils.test (file_path, GLib.FileTest.EXISTS)) {
                return "";
            }

            try {
                GLib.FileUtils.get_contents (file_path, out content);
            } catch (Error e) {
                warning (e.message);
                return "";
            }

            return content.chomp ();
        }

        //public static string[] get_available_values (string path) {
        public static string[] get_available_values () {
            //string val_str = Utils.get_content (CPU_PATH + @"cpu0/cpufreq/scaling_available_$path");
            string val_str = "powersave performance");
            return val_str.split (" ");
        }

        public static double get_cur_frequency () {
            string cur_value;
            double maxcur = 0;

            for (uint i = 0, isize = (int) GLib.get_num_processors (); i < isize; ++i) {
                cur_value = Utils.get_content (CPU_PATH + @"cpu$i/cpufreq/scaling_cur_freq");

                if (cur_value == "") {
                    continue;
                }
                var cur = double.parse (cur_value);
                maxcur = i == 0 ? cur : double.max (cur, maxcur);
            }

            return maxcur;
        }

        public static void run_cli (string cmd_par) {
            string stdout;
            string stderr;
            int status;
            string cli_path = "pkexec /usr/bin/io.elementary.powersave.modifier ";
            string cmd = cli_path + cmd_par;

            try {
                Process.spawn_command_line_sync (
                    cmd,
                    out stdout,
                    out stderr,
                    out status);
            } catch (Error e) {
                warning (e.message);
            }
        }

        private static Polkit.Permission? permission = null;
        public static Polkit.Permission? get_permission () {
            if (permission != null) {
                return permission;
            }

            try {
                permission = new Polkit.Permission.sync ("io.elementary.wingpanel.powersave.controlpwr", new Polkit.UnixProcess (Posix.getpid ()));
                return permission;
            } catch (Error e) {
                critical (e.message);
                return null;
            }
        }

        public static string format_frequency (double val) {
            const string[] units = {
                "{} MHz",
                "{} GHz"
            };
            int index = -1;

            while (index + 1 < units.length && (val >= 1000 || index < 0)) {
                val /= 1000;
                ++index;
            }
            var pattern = units[index].replace ("{}", val <   9.95 ? "%.1f" : "%.0f");
            return pattern.printf (val);
        }
    }
}
