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
using NUnit.Core.Extensibility;
using NUnit.Core;
using NUnit.Framework;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Collections.Generic;



namespace NUnitSquishCoco
{
    [NUnitAddin(Description = "Squish Coco - Code Coverage Recorder for NUnit")]
    public class NUnitSquishCoco : IAddin, EventListener
    {
        public bool Install(IExtensionHost host)
        {
            if (host == null)
                throw new ArgumentNullException("host");

            IExtensionPoint listeners = host.GetExtensionPoint("EventListeners");
            if (listeners == null)
                return false;

            listeners.Install(this);
            return true;
        }

        Coverage coverage = new Coverage();
        StringBuilder sb = new StringBuilder();


        #region EventListener Members

        public void RunStarted(string name, int testCount)
        {
            coverage.StartRun(name, testCount);
        }

        public void RunFinished(TestResult result)
        {
            return;
        }

        public void SuiteStarted(TestName testName)
        {
            return;
        }

        public void TestStarted(TestName testName)
        {
            coverage.StartTest(testName);
        }

        public void TestFinished(TestResult result)
        {
            try
            {
                String message = result.Message;
                if (message.Length > 0)
                {
                    coverage.WriteLine("", false, false);
                    coverage.WriteLine(message, true, false);
                }
            }
            catch { }
            coverage.CompleteTest(result);
        }

        public void SuiteFinished(TestResult result)
        {
            return;
        }
        
        public void RunFinished(Exception exception)
        {
            coverage.CompleteTestWith(exception);
        }

        public void TestOutput(TestOutput testOutput)
        {
            coverage.Write(testOutput.Text, false, true );
        }

        public void UnhandledException(Exception exception)
        {
            coverage.CompleteTestWith(exception);
        }

        #endregion
    }
}
