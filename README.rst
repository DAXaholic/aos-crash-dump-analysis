-------------------------
 AOS Crash Dump Analysis
-------------------------

This project allows you to analyse an AOS crash dump, so that in the end, you
know the context (user, data area etc.) and the corresponding call stack of the
session which caused the crash.

Furthermore it is possible to set up an automatic dump analysis with the aid of
Windows Task Scheduler. If there is created a new dump, the scheduled task will
pick up the dump, analyse it and save the analysis log to a specific directory
along with a compressed version of the dump.


Analyse a Dump
~~~~~~~~~~~~~~~

Invoke script analyse_crash_dump.ps1_ with the path to the crash dump file
as sole argument. If everything was set up correctly, the script should output
the context information followed by the call stack.

.. _analyse_crash_dump.ps1: analyse_crash_dump.ps1
