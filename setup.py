from setuptools import setup, find_packages

setup(
    name="contextflow_plugin",
    version="0.1.0",
    description="MCP上下文管理插件",
    author="Your Name",
    author_email="your.email@example.com",
    packages=find_packages(),
    install_requires=[
        "requests>=2.25.0",
        "aiohttp>=3.7.0",
        "flask",
        "flask-cors"
    ],
    extras_require={
        "dev": [
            "pytest>=6.0.0",
            "pytest-asyncio>=0.14.0",
            "requests-mock>=1.9.0"
        ]
    },
    python_requires=">=3.7",
    entry_points={
        "mcp.plugins": [
            "contextflow=contextflow.plugin:ContextFlowPlugin",
        ],
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
    ],
) 