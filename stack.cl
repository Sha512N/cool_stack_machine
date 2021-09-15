class Stack {

    isNull() : Bool { true };

    head() : String { { abort(); "abort"; } };

    rest() : Stack { { abort(); self; } };

    stack(string: String) : Stack {
        (new StackElement).add(string, self)
	};

};


class StackElement inherits Stack {

    head: String;

    rest: Stack;

    isNull() : Bool { false };

    head() : String { head };

    rest() : Stack { rest };

    add(value: String, list: Stack) : Stack {
	    {
	        head <- value;
	        rest <- list;
	        self;
	    }
	};
};

class Command inherits IO {

    exec(stack: Stack) : Stack {
        { abort(); new Stack; }
    };

};

class CommandAddPlus inherits Command {
    exec(stack: Stack) : Stack {
        (new StackElement).add("+", stack)
    };
};

class CommandAddSwitch inherits Command {
    exec(stack: Stack) : Stack {
        (new StackElement).add("s", stack)
    };
};

class CommandSum inherits Command {
    -- not impl
};

class CommandSwitch inherits Command {
    -- not impl
};

class CommandEval inherits Command {
    -- not impl
};

class CommandExit inherits Command {
    exec(stack: Stack) : Stack {
        {
            abort();
            stack;
        }
    };
};

class CommandDisplay inherits Command {

    newline(): Object {
        out_string("\n")
    };

    exec(stack: Stack) : Stack {
        {
            if stack.isNull() then out_string("")
            else
                {
                    out_string(stack.head());
                    newline();
                    exec(stack.rest());
                }
            fi;
            stack;
        }
    };
};

class CommandExec {

    a2i : A2I;
    display : Command;
    exit : Command;
    addPlus: Command;
    addSwitch: Command;

    set_env() : CommandExec {
        {
            a2i <- new A2I;
            display <- new CommandDisplay;
            exit <- new CommandExit;
            addPlus <- new CommandAddPlus;
            addSwitch <- new CommandAddSwitch;
            self;
        }
    };

    execute(value: String, stack: Stack) : Stack {
        if value = "+" then
            addPlus.exec(stack)
        else
        if value = "s" then
            addSwitch.exec(stack)
        else
        if value = "d" then
            display.exec(stack)
        else
        if value = "e" then
            exit.exec(stack)
        else
        {
            a2i.a2i(value);
            (new StackElement).add(value, stack);
        }
        fi fi fi fi
    };
};

class Main inherits IO {

    prompt() : String {
    	{
    	   out_string(">");
    	   in_string();
    	}
    };

    main(): Object {
        (
            let mainCommand : CommandExec <- (new CommandExec).set_env(), s : Stack <- new Stack in
                while true loop
                    (
                        let data : String <- prompt() in
                            s <- mainCommand.execute(data, s)
                    )
                pool
        )
    };
};