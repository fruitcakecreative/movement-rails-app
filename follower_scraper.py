import requests
from bs4 import BeautifulSoup
import time
import sys

artist_slug = sys.argv[1]


def fetch_ra_followers(artist_slug, retries=2):
    url = f"https://ra.co/dj/{artist_slug}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
                      "(KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
        "Referer": "https://ra.co/",
        "Accept-Language": "en-US,en;q=0.9",
    }

    for attempt in range(retries):
        try:
            response = requests.get(url, headers=headers, timeout=15)
            soup = BeautifulSoup(response.text, "html.parser")

            label = soup.find("span", string="Followers")
            if not label:
                return None

            parent = label.find_parent("li")
            if not parent:
                return None

            value_span = parent.find_all("span")[-1]
            raw = value_span.get_text(strip=True).lower().replace(",", "")

            if "k" in raw:
                return int(float(raw.replace("k", "")) * 1000)
            else:
                return int(raw)

        except requests.exceptions.RequestException as e:
            print(f"⚠️ Attempt {attempt + 1} failed: {e}")
            time.sleep(3)

    return None

followers = fetch_ra_followers(artist_slug)
print(followers if followers is not None else 0)
