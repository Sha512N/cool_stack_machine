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
    a2i: A2I;

    set_env(a2i_input: A2I) : Command {
        {
            a2i <- a2i_input;
            self;
        }
    };

    exec(stack: Stack) : Stack {
        (
            let operand1: Int <- a2i.a2i(stack.head()),
                operand2: Int <- a2i.a2i(stack.rest().head()),
                stack_new: Stack <- stack.rest().rest() in
                {
                    (new StackElement).add(a2i.i2a(operand1 + operand2), stack_new);
                }
        )
    };
};

class CommandSwitch inherits Command {
    exec(stack: Stack) : Stack {
        (
            let operand1: String <- stack.head(),
                operand2: String <- stack.rest().head(),
                stack_new: Stack <- stack.rest().rest() in
                {
                    (new StackElement).add(operand2, (new StackElement).add(operand1, stack_new));
                }
        )
    };
};

class CommandEval inherits Command {

    sum: Command;
    switch: Command;

    set_env(a2i_input: A2I) : Command {
        {
            sum <- (new CommandSum).set_env(a2i_input);
            switch <- new CommandSwitch;
            self;
        }
    };

    exec(stack: Stack) : Stack {
        if stack.head() = "s" then
            switch.exec(stack.rest())
        else
        if stack.head() = "+" then
            sum.exec(stack.rest())
        else
            stack
        fi fi
    };
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
    eval: Command;

    set_env() : CommandExec {
        {
            a2i <- new A2I;
            display <- new CommandDisplay;
            exit <- new CommandExit;
            addPlus <- new CommandAddPlus;
            addSwitch <- new CommandAddSwitch;
            eval <- (new CommandEval).set_env(a2i);
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
        if value = "x" then
            exit.exec(stack)
        else
        if value = "e" then
            eval.exec(stack)
        else
        {
            a2i.a2i(value);
            (new StackElement).add(value, stack);
        }
        fi fi fi fi fi
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