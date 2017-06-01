﻿using System;
using System.Collections.Generic;
using System.Threading;
using TGServiceInterface;

namespace TGCommandLine
{
	class DMCommand : RootCommand
	{
		public DMCommand()
		{
			Keyword = "dm";
			Children = new Command[] { new DMCompileCommand(), new DMInitializeCommand(), new DMStatusCommand(), new DMSetProjectNameCommand(), new DMCancelCommand() };
		}
		protected override string GetHelpText()
		{
			return "Manage compiling the server";
		}
	}

	class DMCompileCommand : Command
	{
		public DMCompileCommand()
		{
			Keyword = "compile";
		}

		public override ExitCode Run(IList<string> parameters)
		{
			var DM = Server.GetComponent<ITGCompiler>();
			var stat = DM.GetStatus();
			if (stat != TGCompilerStatus.Initialized)
			{
				Console.WriteLine("Error: Compiler is " + ((stat == TGCompilerStatus.Uninitialized) ? "unintialized!" : "busy with another task!"));
				return ExitCode.ServerError;
			}

			if (Server.GetComponent<ITGByond>().GetVersion(TGByondVersion.Installed) == null)
			{
				Console.Write("Error: BYOND is not installed!");
				return ExitCode.ServerError;
			}

			if (!DM.Compile())
			{
				Console.WriteLine("Error: Unable to start compilation!");
				var err = DM.CompileError();
				if (err != null)
					Console.WriteLine(err);
				return ExitCode.ServerError;
			}
			Console.WriteLine("Compile job started");
			if (parameters.Count > 0 && parameters[0] == "--wait")
			{
				do
				{
					Thread.Sleep(1000);
				} while (DM.GetStatus() == TGCompilerStatus.Compiling);
				var res = DM.CompileError();
				Console.WriteLine(res ?? "Compilation successful");
				if (res != null)
					return ExitCode.ServerError;
			}
			return ExitCode.Normal;
		}

		protected override string GetArgumentString()
		{
			return "[--wait]";
		}

		protected override string GetHelpText()
		{
			return "Starts a compile/update job optionally waiting for completion";
		}
	}
	class DMStatusCommand : Command
	{
		public DMStatusCommand()
		{
			Keyword = "status";
		}

		void ShowError()
		{
			var error = Server.GetComponent<ITGCompiler>().CompileError();
			if (error != null)
				Console.WriteLine("Last error: " + error);
		}

		public override ExitCode Run(IList<string> parameters)
		{
			var DM = Server.GetComponent<ITGCompiler>();
			Console.WriteLine(String.Format("Target Project: /{0}.dme", DM.ProjectName()));
			Console.Write("Compilier is currently: ");
			switch (DM.GetStatus())
			{
				case TGCompilerStatus.Compiling:
					Console.WriteLine("Compiling...");
					break;
				case TGCompilerStatus.Initialized:
					Console.WriteLine("Idle");
					ShowError();
					break;
				case TGCompilerStatus.Initializing:
					Console.WriteLine("Setting up...");
					break;
				case TGCompilerStatus.Uninitialized:
					Console.WriteLine("Uninitialized");
					ShowError();
					break;
				default:
					Console.WriteLine("Seizing the means of production (This is an error).");
					return ExitCode.ServerError;
			}		
			return ExitCode.Normal;
		}

		protected override string GetHelpText()
		{
			return "Get the current status of the compiler";
		}
	}

	class DMSetProjectNameCommand : Command
	{
		public DMSetProjectNameCommand()
		{
			Keyword = "project-name";
			RequiredParameters = 1;
		}
		protected override string GetArgumentString()
		{
			return "<path>";
		}

		protected override string GetHelpText()
		{
			return "Set the relative path of the .dme/.dmb to compile/run";
		}

		public override ExitCode Run(IList<string> parameters)
		{
			Server.GetComponent<ITGCompiler>().SetProjectName(parameters[0]);
			return ExitCode.Normal;
		}
	}

	class DMInitializeCommand : Command
	{
		public DMInitializeCommand()
		{
			Keyword = "initialize";
		}

		protected override string GetArgumentString()
		{
			return "[--wait]";
		}

		protected override string GetHelpText()
		{
			return "Starts an initialization job optionally waiting for completion";
		}

		public override ExitCode Run(IList<string> parameters)
		{
			var DM = Server.GetComponent<ITGCompiler>();
			var stat = DM.GetStatus();
			if (stat == TGCompilerStatus.Compiling || stat == TGCompilerStatus.Initializing)
			{
				Console.WriteLine("Error: Compiler is " + ((stat == TGCompilerStatus.Initializing) ? "already initialized!" : " already running!"));
				return ExitCode.ServerError;
			}
			if (!DM.Initialize())
			{
				Console.WriteLine("Error: Unable to start initialization!");
				var err = DM.CompileError();
				if (err != null)
					Console.WriteLine(err);
				return ExitCode.ServerError;
			}
			Console.WriteLine("Initialize job started");
			if (parameters.Count > 0 && parameters[0] == "--wait")
			{
				do
				{
					Thread.Sleep(1000);
				} while (DM.GetStatus() == TGCompilerStatus.Initializing);
				var res = DM.CompileError();
				Console.WriteLine(res ?? "Initialization successful");
				if (res != null)
					return ExitCode.ServerError;
			}
			return ExitCode.Normal;
		}
	}
	
	class DMCancelCommand : Command
	{
		public DMCancelCommand()
		{
			Keyword = "cancel";
		}

		public override ExitCode Run(IList<string> parameters)
		{
			var res = Server.GetComponent<ITGCompiler>().Cancel();
			Console.WriteLine(res ?? "Success!");
			return ExitCode.Normal;	//because failing cancellation implys it's already cancelled
		}

		protected override string GetHelpText()
		{
			return "Cancels the current compilation job";
		}
	}
}
