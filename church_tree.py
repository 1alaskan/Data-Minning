import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.tree import DecisionTreeClassifier, plot_tree, export_text
from sklearn.metrics import accuracy_score, confusion_matrix, roc_curve, auc
import matplotlib.pyplot as plt
import time

start = time.time()

# ─── 1. Load & Encode ──────────────────────────────────────────────
file_path = r"C:\Users\spink\Downloads\Ch13_Q15_Data_File (1).xlsx"
df = pd.read_excel(file_path, sheet_name="Church")
df_encoded = df.copy()
df_encoded['Sex'] = df_encoded['Sex'].map({'F': 0, 'M': 1})
df_encoded['Married'] = df_encoded['Married'].map({'N': 0, 'Y': 1})

X = df_encoded[['Educ', 'Income', 'Age', 'Sex', 'Married']]
y = df_encoded['Church']

# ─── 2. Train/Test Split ───────────────────────────────────────────
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=321
)

# ─── 3. Get ALL cost complexity pruning path alphas ─────────────────
full_tree = DecisionTreeClassifier(random_state=321)
full_tree.fit(X_train, y_train)
path = full_tree.cost_complexity_pruning_path(X_train, y_train)
ccp_alphas = path.ccp_alphas
print(f"Total ccp_alpha values: {len(ccp_alphas)}")

# ─── 4. GridSearchCV with full alpha grid ───────────────────────────
param_grid = {
    'ccp_alpha': ccp_alphas,
    'max_depth': list(range(1, 11)),
    'min_samples_leaf': list(range(1, 11))
}
print(f"Total combos: {len(ccp_alphas)*10*10} (this may take a few minutes...)")

dt = DecisionTreeClassifier(random_state=321)
grid_search = GridSearchCV(dt, param_grid, scoring='accuracy', cv=10, n_jobs=-1)
grid_search.fit(X_train, y_train)

elapsed = time.time() - start
print(f"Grid search completed in {elapsed:.1f} seconds")

best_tree = grid_search.best_estimator_
print(f"Best params: {grid_search.best_params_}")
print(f"Best CV accuracy: {grid_search.best_score_:.4f}")

# ─── a-1 ────────────────────────────────────────────────────────────
n_leaves = best_tree.get_n_leaves()
print(f"\na-1. Leaf nodes: {n_leaves}")

# ─── Tree rules ─────────────────────────────────────────────────────
feature_names = ['Educ', 'Income', 'Age', 'Sex', 'Married']
print(f"\nTree Rules:\n{export_text(best_tree, feature_names=feature_names)}")

plt.figure(figsize=(20, 10))
plot_tree(best_tree, feature_names=feature_names,
          class_names=['No', 'Yes'], filled=True, rounded=True, fontsize=10)
plt.tight_layout()
plt.savefig(r"C:\Users\spink\OneDrive\Desktop\Data Minning\church_tree_plot.png", dpi=150)
plt.close()

# ─── b: Metrics ─────────────────────────────────────────────────────
y_pred = best_tree.predict(X_test)
cm = confusion_matrix(y_test, y_pred)
tn, fp, fn, tp = cm.ravel()
accuracy = accuracy_score(y_test, y_pred)
sensitivity = tp / (tp + fn)
specificity = tn / (tn + fp)
precision_val = tp / (tp + fp)

print(f"\nb. Accuracy:    {accuracy*100:.2f}%")
print(f"   Specificity: {specificity*100:.2f}%")
print(f"   Sensitivity: {sensitivity*100:.2f}%")
print(f"   Precision:   {precision_val*100:.2f}%")

# ─── c: AUC ─────────────────────────────────────────────────────────
y_prob = best_tree.predict_proba(X_test)[:, 1]
fpr, tpr, _ = roc_curve(y_test, y_prob)
roc_auc = auc(fpr, tpr)
print(f"\nc. AUC: {roc_auc:.4f}")

plt.figure(figsize=(8, 6))
plt.plot(fpr, tpr, 'b-', lw=2, label=f'ROC (AUC = {roc_auc:.4f})')
plt.plot([0, 1], [0, 1], 'r--')
plt.xlabel('1 - Specificity'); plt.ylabel('Sensitivity')
plt.title('ROC Curve'); plt.legend(); plt.grid(True)
plt.savefig(r"C:\Users\spink\OneDrive\Desktop\Data Minning\church_roc_curve.png", dpi=150)
plt.close()

# ─── d: Score full dataset ──────────────────────────────────────────
score_proba = best_tree.predict_proba(X)[:, 1]
score_pred = (score_proba >= 0.5).astype(int)
pct_likely = score_pred.mean() * 100
print(f"\nd. Percent likely to attend church: {pct_likely:.2f}%")
