defmodule RaiseExceptionTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec
    let :func1, do: fn -> 1+"test" end
    let :func2, do: fn -> 1+1 end
    let :func3, do: fn -> List.first(:a) end

    context "Success" do
      it do: expect(func1).to raise_exception
      it do: expect(func1).to raise_exception(ArithmeticError)
      it do: expect(func1).to raise_exception(ArithmeticError, "bad argument in arithmetic expression")

      it do: expect(func2).to_not raise_exception
      it do: expect(func2).to_not raise_exception(ArithmeticError, "bad argument in arithmetic expression")
      it do: expect(func2).to_not raise_exception(ArithmeticError)

      it do: expect(func3).to_not raise_exception(ArithmeticError)
      it do: expect(func3).to_not raise_exception(FunctionClauseError, "no such message")
    end

    context "Errors" do
      it do: expect(func2).to raise_exception
      it do: expect(func2).to raise_exception(ArithmeticError)
      it do: expect(func2).to raise_exception(ArithmeticError, "bad argument in arithmetic expression")

      it do: expect(func1).to_not raise_exception
      it do: expect(func1).to_not raise_exception(ArithmeticError)
      it do: expect(func1).to_not raise_exception(ArithmeticError, "bad argument in arithmetic expression")

      it do: expect(func3).to_not raise_exception(FunctionClauseError)
      it do: expect(func3).to_not raise_exception(FunctionClauseError, "no function clause matching in List.first/1")
    end

  end

  setup_all do
    examples = ESpec.Runner.run_examples(SomeSpec.examples, SomeSpec)
    { :ok,
      success: Enum.slice(examples, 0, 7),
      errors: Enum.slice(examples, 8, 15)
    }
  end

  test "Success", context do
    Enum.each(context[:success], fn(ex) ->
      assert(ex.success == true)
    end)
  end

  test "Errors", context do
    Enum.each(context[:errors], fn(ex) ->
      assert(ex.success == false)
    end)
  end

end
