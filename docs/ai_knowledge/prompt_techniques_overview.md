# Prompt Techniques Overview

Master foundational prompting styles that form the building blocks of effective AI-assisted development.

## 🎯 Foundational Techniques

These core techniques provide the foundation for all advanced prompting. Master these before moving to sophisticated methods.

## 📝 Basic Prompting Styles

### Zero-Shot Prompting
**What it is**: Asking the model to perform a task without any prior examples

**When to use**:
- Simple, well-defined tasks
- General questions and explanations
- Code snippets and basic functions
- Tasks that rely on the model's pre-trained knowledge

**Example**:
```
Write a Python function to calculate the factorial of a number.
```

**Pros**: Simple and direct
**Cons**: Limited control over output format and style

### Few-Shot Prompting
**What it is**: Providing 1-5 input-output examples to demonstrate the desired pattern

**When to use**:
- Enforcing specific coding styles
- Ensuring consistent output formats
- Teaching custom logic or patterns
- Aligning with team conventions

**Example**:
```
Please generate Golang unit tests that adhere to the following conventions:
- Use table-driven tests for different input cases
- Use the require package from testify for assertions

Example:
func TestAdd(t *testing.T) {
  testCases := []struct{ name string; a, b, expected int }{
    {"positive", 1, 2, 3},
    {"negative", -1, -2, -3},
  }
  for _, tc := range testCases {
    t.Run(tc.name, func(t *testing.T) {
      result := Add(tc.a, tc.b)
      require.Equal(t, tc.expected, result)
    })
  }
}

Now, generate a test for the following function:
func Subtract(a, b int) int { return a - b }
```

**Best Practices**:
- Use high-quality, relevant examples
- Maintain consistent formatting
- Order examples from simple to complex
- Include varied scenarios to cover edge cases

## 🎭 Role-Based Prompting

### Expert Persona Prompting
**What it is**: Instructing the AI to act as an expert in a specific domain

**When to use**:
- Code reviews and security audits
- Performance optimization
- Domain-specific implementations
- Architectural decisions

**Example**:
```
Act as a senior backend engineer with 10 years of experience in distributed systems.
Review this microservice architecture and identify potential scalability bottlenecks.
```

**Benefits**:
- Leverages domain-specific knowledge patterns
- Improves output quality and relevance
- Reduces the need for detailed technical explanations

### Multi-Persona Collaboration
**What it is**: Having multiple expert personas work together on a complex problem

**Example**:
```
We have a complex system design problem. Let's have three experts collaborate:

1. A Senior SRE to focus on reliability and monitoring
2. A Security Architect to address security concerns
3. A Performance Engineer to optimize for scale

Each expert should provide their perspective on this architecture...
```

## 📋 Structured Prompting

### Clear Instructions
**What it is**: Using explicit, unambiguous instructions

**Best practices**:
- Be specific about what you want
- Include acceptance criteria
- Specify output format when needed
- Break complex tasks into steps

**Example**:
```
Create a React component that:
1. Accepts a user object as props
2. Displays user name, email, and avatar
3. Shows "Online" status if user.isOnline is true
4. Uses Tailwind CSS for styling
5. Is fully typed with TypeScript

The component should be functional, use hooks, and follow React best practices.
```

### Output Format Specification
**What it is**: Explicitly defining the desired output structure

**When to use**:
- Code that will be consumed programmatically
- Structured data generation
- API responses and schemas
- Documentation templates

**Example**:
```
Generate a JSON object with the following structure:
{
  "function_name": "string",
  "parameters": ["array", "of", "strings"],
  "return_type": "string",
  "time_complexity": "O(n)",
  "space_complexity": "O(1)"
}
```

## 🔄 Iterative Prompting

### Progressive Refinement
**What it is**: Starting with a basic prompt and iteratively improving it

**Process**:
1. Start with a simple, clear request
2. Review the output for gaps or issues
3. Refine the prompt to address problems
4. Repeat until satisfied

**Example**:
```
Initial: "Write a function to sort a list"
Refined: "Write a Python function to sort a list of integers in ascending order"
Further refined: "Write a Python function that takes a list of integers and returns a new sorted list. Use the built-in sorted() function. Include type hints and a docstring."
```

### Feedback Loops
**What it is**: Using the AI's output to improve subsequent prompts

**Example**:
```
AI: [Provides a solution]
You: "Good, but I need it to handle edge cases like empty lists and None values"
AI: [Provides improved solution]
You: "Perfect! Now add error handling for invalid input types"
```

## 🎯 Technique Selection Guide

| Task Type | Recommended Technique | Why |
|-----------|----------------------|-----|
| **Simple code generation** | Zero-shot | Quick and direct |
| **Style enforcement** | Few-shot | Shows exact patterns |
| **Code review** | Role prompting | Leverages expertise |
| **Complex logic** | Structured + iterative | Ensures completeness |
| **API design** | Output format specification | Ensures consistency |
| **Debugging** | Progressive refinement | Iterative problem-solving |

## 🛠️ Best Practices

### Clarity and Specificity
- Be explicit about requirements
- Include concrete examples
- Specify constraints and limitations
- Define success criteria

### Context Matters
- Provide relevant background information
- Include necessary constraints
- Reference existing code or patterns
- Specify the target environment

### Iteration and Improvement
- Start simple and build complexity
- Learn from failures and successes
- Document effective patterns
- Share successful prompts with your team

### Quality Assurance
- Review outputs critically
- Test generated code
- Validate against requirements
- Refine based on results

## 🚀 Getting Started

1. **Master Zero-Shot**: Practice with simple, clear requests
2. **Add Few-Shot Examples**: Learn to provide effective examples
3. **Experiment with Roles**: Try different expert personas
4. **Structure Your Prompts**: Use clear instructions and format specifications
5. **Iterate and Improve**: Refine based on results

## 📖 Next Steps

- **[Context Engineering](context_engineering.md)** - Learn to provide effective context
- **[Advanced Prompting](advanced_prompting.md)** - Master sophisticated reasoning techniques
- **[AI Workflows](ai_workflows/index.md)** - Apply techniques in real-world scenarios

---

**Ready to build on these foundations?** Move to **[Context Engineering](context_engineering.md)** to learn how to provide the right context for these techniques.
