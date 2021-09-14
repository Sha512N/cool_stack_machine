class Stack {

	isNull() : Bool { true };

	head() : String { { abort(); "abort"; } };

	rest() : Stack { { abort(); self; } };

	stack(string: String) : Stack {
        (new StackElement).create(string, self)
	};

};


class StackElement inherits Stack {

    head: String;

    rest: Stack;

	isNull() : Bool { false };

	head() : String { head };

	rest() : Stack { rest };

	create(value: String, list: Stack) : Stack {
	    {
	        head <- value;
	        rest <- list;
	        self;
	    }
	}
};

class Command inherits IO {
    -- not impl
};

class CommandInt inherits Command {
    -- not impl
};

class CommandPlus inherits Command {
    -- not impl
};

class CommandSwitch inherits Command {
-- not impl
};

class CommandEval inherits Command {
    -- not impl
};

class CommandDisplay inherits Command {
    -- not impl
};

class Main inherits IO {
    -- not impl
};