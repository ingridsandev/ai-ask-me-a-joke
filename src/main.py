import os
import anthropic

def lambda_handler(event, context):
    # Load your Anthropic API key from the environment variable
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    
    if api_key is None:
        raise ValueError("Please set the ANTHROPIC_API_KEY environment variable.")

    # Initialize the API client
    client = anthropic.Anthropic(api_key=api_key)

    # Ask Claude for a joke
    response = client.messages.create(
        model="claude-3-7-sonnet-20250219",
        max_tokens=100,
        temperature=0.7,
        messages=[
            {"role": "user", "content": "Tell me a joke."}
        ]
    )

    # Return the result
    return {
        'statusCode': 200,
        'body': response.content[0].text
    }