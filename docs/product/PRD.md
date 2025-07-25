# Product Requirements Document (PRD)

## 📌 Problem

Traditional Kubernetes autoscaling mechanisms like HPA/VPA rely on reactive strategies, often leading to overprovisioned resources. While this ensures availability, it results in higher infrastructure costs and inefficient usage of cloud resources.

## 🎯 Product Goal

Kapetanios aims to provide an intelligent, proactive autoscaling solution based on ML models trained on real cluster data. It predicts resource usage patterns and makes scaling decisions that reduce costs **without compromising service quality**.

## 🧬 Key Differentiator

- Fully open source, including training and inference pipelines.
- Accessible to researchers, small teams, and cloud-native engineers.
- Allows both experimentation and commercial use with minimal entry barrier.
- Reduces the operational burden on infrastructure engineers.
- Can be plugged into any Kubernetes cluster (cloud or on-prem).

## 👥 Target Users

- DevOps Engineers
- Site Reliability Engineers (SREs)
- Platform Engineers
- AI practitioners working with cloud infrastructure
- Researchers in intelligent systems and cloud optimization

## 🔧 Expected Use Cases

- Integration in test/staging Kubernetes clusters to validate ML-based autoscaling.
- Usage in production environments to optimize cloud costs.
- Educational/research deployments to experiment with autoscaling strategies.
- Organizations wanting control over autoscaling without vendor lock-in.

## 🗺️ Roadmap Vision

1. ✅ **Proof of Concept (PoC)** – building the end-to-end flow with working components.
2. 🧪 **Stable version v1.0** – full agent, frontend, backend, ML core and model selector.
3. 🚀 **Public release and documentation** – open beta with installation and usage guides.
4. 📣 **Feedback and community validation** – refine product direction via real-world usage.
5. 🔁 **Data-as-a-Service option** – optionally offer a data ingestion and tuning feedback loop for enterprise usage.

## 🤝 How to Contribute

We welcome contributions from the open source community.

1. Fork the repo and create a feature branch.
2. Follow our naming convention (`feat:`, `fix:`, `chore:`, `doc:`).
3. Ensure your code passes lint/tests where applicable.
4. Write meaningful commit messages and PR titles.
5. Link the PR to a related Issue and describe the rationale clearly.
6. Start with issues labeled `good first issue` or `help wanted`.

## 📁 File Structure (planned)

kapetanios/
├── agent/ # Go agent to collect and apply autoscaling
├── backend/ # API to serve and trigger ML models
├── frontend/ # Web UI for monitoring, control and training
├── ml-core/ # Data preprocessing, model training and inference
├── docs/ # Full documentation (ReadTheDocs-ready)
└── .github/ # CI/CD and community templates


## 📌 License

Kapetanios is released under the [MIT License](../LICENSE).
