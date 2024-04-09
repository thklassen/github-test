/**********************************************************************
** Copyright (C) 2014 froglogic GmbH.
** All rights reserved.
**
** This file is part of Squish Coco.
**
** Licensees holding valid commercial Squish Coco licenses may use
** this file in accordance with the commercial license agreement
** provided with the Software or, alternatively, in accordance with
** the terms contained in a written agreement between the licensee and
** froglogic GmbH.
** For licensing terms and conditions see the LICENSE-SQUISH-COCO.TXT
** file in the toplevel directory of this package.
**
** Contact contact@froglogic.com if any conditions of this licensing are
** not clear to you.
**
**********************************************************************/

using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Reflection;

namespace NUnitSquishCoco
{
    class Coverage
    {
        enum State { PASSED, FAILED, CHECK_MANUALLY, UNKNOWN };

        private string csexe_filename = "";

        internal void StartRun(string name, int testCount)
        {
            csexe_filename = name;
            CoverageCleanup();
        }

        private NUnit.Core.TestName current_testname = null;

        internal void StartTest(NUnit.Core.TestName testName)
        {
            CoverageCleanup();
            current_testname = testName;
        }

        internal void CompleteTest(NUnit.Core.TestResult result)
        {
            State state = State.UNKNOWN;
            if (!result.Executed)
                return;
            try
            {
                if (result.IsFailure)
                    state = State.FAILED;
                if (result.IsError)
                    state = State.CHECK_MANUALLY;
                if (result.IsSuccess)
                    state = State.PASSED;
            }
            catch
            {
            }
            CoverageRecord(csexe_filename, current_testname, state);
        }

        internal void CompleteTestWith(Exception exception)
        {
            try
            {
                WriteLine("", false, false);
                WriteLine("==== Exception ====", true, false);
                WriteLine(exception.Message, true, true);
            }
            catch
            {
            }
            CoverageRecord(csexe_filename, current_testname, State.CHECK_MANUALLY);
        }

        internal void Write(String text, bool bold, bool italic)
        {
            CoverageTextLog(text, bold, italic);
        }

        internal void WriteLine(String text, bool bold, bool italic )
        {
            Write(text +  "\n", bold, italic );
        }

        private static void CoverageCleanup()
        {
            AppDomain MyDomain = AppDomain.CurrentDomain;
            Assembly[] AssembliesLoaded = MyDomain.GetAssemblies();

            foreach (Assembly a in AssembliesLoaded)
            {
                Type coco = a.GetType("CoverageScanner");
                if (coco != null)
                {
                    // clear all coverage information to only get the code coverage of the current executed unit test
                    coco.InvokeMember("__coveragescanner_clear", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, null);
                    coco.InvokeMember("__coveragescanner_clear_html_comment", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, null);
                }
            }
        }


        private static void CoverageTextLog(String text, bool bold, bool italic )
        {
            String style_begin = "";
            String style_end = "";
            if (italic)
            {
                style_begin += "<I>";
                style_end += "</I>";
            }
            if (bold)
            {
                style_begin += "<B>";
                style_end += "</B>";
            }

            String comment = "<HTML><BODY><TT>"
                            + style_begin
                            + text.Replace("&", "&amp;")
                                    .Replace("<", "&lt;")
                                    .Replace(">", "&gt;")
                                    .Replace("\"", "&quot;")
                                    .Replace("'", "&apos;")
                                    .Replace("\n", "<BR>")
                                    .Replace("\r", "")
                            + style_end
                            + "</TT></BODY></HTML>"
                            ;
            CoverageHtmlLog(comment);
        }

        private static void CoverageHtmlLog(String comment)
        {
            AppDomain MyDomain = AppDomain.CurrentDomain;
            Assembly[] AssembliesLoaded = MyDomain.GetAssemblies();

            foreach (Assembly a in AssembliesLoaded)
            {
                Type coco = a.GetType("CoverageScanner");
                if (coco != null)
                {
                    coco.InvokeMember("__coveragescanner_add_html_comment", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, new object[] { comment });
                }
            }
        }

        private static void CoverageRecord(String csexe_filename, NUnit.Core.TestName testName, State result)
        {
            if (csexe_filename == "")
                return;

            AppDomain MyDomain = AppDomain.CurrentDomain;
            Assembly[] AssembliesLoaded = MyDomain.GetAssemblies();

            foreach (Assembly a in AssembliesLoaded)
            {
                Type coco = a.GetType("CoverageScanner");
                if (coco != null)
                {
                    String name = "unknown";
                    String state = "";

                    switch (result)
                    {
                        case State.FAILED:
                            state = ("FAILED");
                            break;
                        case State.CHECK_MANUALLY:
                            state = ("CHECK_MANUALLY");
                            break;
                        case State.PASSED:
                            state = ("PASSED");
                            break;
                    }

                    if (testName != null)
                    {
                        name = testName.FullName;
                        name = name.Replace('.', '/');
                    }

                    // set the execution state: PASSES, FAILED or CHECK_MANUALLY
                    coco.InvokeMember("__coveragescanner_teststate", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, new object[] { state });

                    if ( name.Length > 0 )
                    // Test name: Namespace/Class/Testfunction
                    coco.InvokeMember("__coveragescanner_testname", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, new object[] { name });

                    // File name is <classname>.csexe 
                    coco.InvokeMember("__coveragescanner_filename", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, new object[] { csexe_filename });
                    // saves the code coverage data
                    coco.InvokeMember("__coveragescanner_save", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, null);
                    // clear all coverage information to only get the code coverage of the current executed unit test
                    coco.InvokeMember("__coveragescanner_clear", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, null);
                    coco.InvokeMember("__coveragescanner_clear_html_comment", BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public, null, null, null);
                }
            }
        }
    }

}
