import json
import time
from duckduckgo_search import DDGS


def get_questions_for_subjects(subjects, max_results_per_subject=10):
    data = {}

    with DDGS() as ddgs:
        for subject in subjects:
            query = f"اسئلة وزارية {subject} السادس الاعدادي pdf"
            print(f"جاري البحث عن: {subject}...")
            items = []

            try:
                results = ddgs.text(query, max_results=max_results_per_subject)
                if results:
                    for r in results:
                        items.append({
                            "title": r.get("title", "بدون عنوان"),
                            "link": r.get("href", ""),
                            "snippet": r.get("body", ""),
                        })
            except Exception as e:
                print(f"حدث خطأ أثناء البحث عن {subject}: {e}")

            data[subject] = items
            # انتظار ثانيتين بين كل مادة لتقليل احتمالية الحظر
            time.sleep(2)

    return data


def main():
    subjects = [
        "الفيزياء",
        "الكيمياء",
        "الرياضيات",
        "الاحياء",
        "اللغة العربية",
        "اللغة الانجليزية",
    ]

    questions_data = get_questions_for_subjects(subjects)

    with open("questions_data.json", "w", encoding="utf-8") as file:
        json.dump(questions_data, file, ensure_ascii=False, indent=4)

    print("تم حفظ البيانات بنجاح في ملف questions_data.json")


if __name__ == "__main__":
    main()
