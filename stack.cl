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

    newline(): Object {
        out_string("\n")
    };

    init(value: String, stack: Stack) : Stack {
        if value = "+" then
            (new StackElement).add(value, stack)
        else
        if value = "s" then
            (new StackElement).add(value, stack)
        else
        if value = "d" then
            (new CommandDisplay).exec(stack)
        else
        if value = "e" then
            (new CommandExit).exec(stack)
        else
            (new StackElement).add(value, stack)
        fi fi fi fi
    };

    exec(stack: Stack) : Stack {
        { abort(); new Stack; }
    };
};

class CommandPlus inherits Command {

    a2i : A2I;

    set_a2i(input: A2I) : Command {
        {
            a2i <- input;
            self;
        }
    };

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

class Main inherits IO {

    s: Stack;

    prompt() : String {
    	{
    	   out_string(">");
    	   in_string();
    	}
    };

    main(): Object {
        (
            let mainCommand : Command <- new Command, s : Stack <- new Stack in
                while true loop
                    (
                        let data : String <- prompt() in
                            s <- mainCommand.init(data, s)
                    )
                pool
        )
    };
};