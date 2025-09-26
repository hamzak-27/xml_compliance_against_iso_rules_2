#!/usr/bin/env python3
"""
Test script to verify OpenAI client initialization works with fixed dependencies.
"""

import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def test_openai_import():
    """Test if OpenAI can be imported and initialized without errors"""
    try:
        from openai import OpenAI
        print("✓ OpenAI library imported successfully")
        
        # Test client initialization
        api_key = os.getenv("OPENAI_API_KEY", "test-key")
        client = OpenAI(api_key=api_key)
        print("✓ OpenAI client initialized successfully")
        
        print("\n🎉 SUCCESS: OpenAI dependency issue is fixed!")
        return True
        
    except Exception as e:
        print(f"❌ ERROR: {str(e)}")
        print("\n🚨 The dependency issue still exists.")
        return False

if __name__ == "__main__":
    print("Testing OpenAI dependency fix...")
    print("=" * 50)
    test_openai_import()